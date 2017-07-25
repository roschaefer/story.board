/*
 * Place all the behaviors and hooks related to the matching controller here.
 * All this logic will automatically be available in application.js.
 */

var Editor = (function($, autosize) {

    /*
     * Creates an instance of the Editor class
     * 
     * @constructor
     * @param {jQuery} $editor The wrapping text editor element
     */
    function Editor($editor) {
        this.options = {
            selector: {
                toolbar: '.text-editor__toolbar:first',
                field:   '.text-editor__field',
            }
        }

        this.$editor  = $editor;
        this.$toolbar = $editor.find(this.options.selector.toolbar);
        this.$fields  = $editor.find(this.options.selector.field);
        this.data = this.$editor.data('editorData');

        this.lastFocus = null;

        this.init();

        var self = this;

        /*
         * By adding or removing elements to the commands property,
         * you can add custom commands, e. g. to insert the markup
         * for an image or a link.
         *
         * @type {function[]}
         */
        this.commands = {
            'text': function($context) {
                return $context.data().editorMarkupText;
            },
        };
    };

    /*
     * Sets event listeners on the editor and its child elements
     * 
     * @returns {Editor}
     */
    Editor.prototype.init = function() {
        var self = this;

        // set all event handlers on toolbar buttons
        self.$toolbar.find('[data-editor-markup-command]').on('click', function(e) {
            e.preventDefault();

            var command = $(this).data().editorMarkupCommand;

            self.recoverFocus();
            self.runCommand(command, $(this));
        });

        self.$toolbar.find('[data-editor-markup-select]').on('change', function(e) {
            var $option = $(this).find(':selected');
            var command = $option.data().editorMarkupCommand;

            self.recoverFocus();
            self.runCommand(command, $option);
        });

        // initiate all fields
        self.$fields.each(function() {
            var field = new Field($(this), self);
            $(this).data('editor-field', field);
        });

        return this;
    };

    /*
     * Inserts a string at the current cursor position in the
     * currently active field
     * 
     * @param {string} string The text to be inserted
     * @returns {Editor}
     */
    Editor.prototype.insertText = function(string) {
        var activeField = this.findActiveField();

        if(activeField) {
            activeField.insertText(string);
        }

        return this;
    };

    /*
     * Run a command to manipulate editor field contents
     *
     * @param {String} command
     * @param {jQuery} $context
     * @returns {Editor}
     */
    Editor.prototype.runCommand = function(command, $context) {
        var command = this.commands[command];

        if(typeof command !== 'function') throw new Error('Command not defined: ' + $context.data().editorMarkupCommand);

        this.insertText(command($context));

        return this;
    };

    /*
     * Return a focussed field
     *
     * @returns {Field}
     */
    Editor.prototype.findActiveField = function() {
        var $field = this.$fields.filter(function() {
            return $(this).data('editorField').isFocussed();
        });

        if($field.length > 0) {
            return $field.data('editorField');
        } else {
            return null;
        }
    };

    /*
     * Saves the passed (focused) field to recover the current
     * focus state later
     *
     * @param {Field} field
     * @returns {Editor}
     */
    Editor.prototype.saveFocus = function(field) {
        this.lastFocus = field;

        return this;
    };

    /*
     * Set the focus to a previously saved field
     *
     * @returns {Editor}
     */
    Editor.prototype.recoverFocus = function() {
        if(this.lastFocus) {
            this.lastFocus.focus();
        }

        return this;
    };

    /*
     * Creates an instance of the Field class
     *
     * @constructor
     * @param {jQuery} $field The field element
     * @param {Editor} editor The editor the field belongs to
     */
    function Field($field, editor) {
        this.editor = editor;
        
        this.$field = $field;
        this.$input = $field.find('.field__input');
        this.$mirror = null;
        this.$count = $field.find('.field__count');

        this.init();
    };


    /*
     *
     */
    Field.prototype.filters = {
        sensors: {
            pattern: /{\s*value\(\s*(\d+)\s*\)\s*}/g,
            markup: function(markup, id) {
                var cls = ['markup', 'markup--sensor'];
                if(!this.editor.data.sensors[id]) cls.push('markup--error');
                
                return '<span class="' + cls.join(' ') + '">' + markup + '</span>';
            },
            tooltip: function(markup, id) {
                if(name = this.editor.data.sensors[id]) {
                    return name;
                }
                return false;
            }
        },
        events: {
            pattern: /{\s*date\(\s*(\d+)\s*\)\s*}/g,
            markup: function(markup, id) {
                var cls = ['markup', 'markup--event'];
                if(!this.editor.data.events[id]) cls.push('markup--error');
                
                return '<span class="' + cls.join(' ') + '">' + markup + '</span>';
            },
            tooltip: function(markup, id) {
                if(name = this.editor.data.events[id]) {
                    return name;
                }
                return false;
            },
        },
    };


    /*
     * Initiate the field's dom node
     *
     * @return {Field}
     */
    Field.prototype.init = function() {
        var self = this;

        self.$mirror = $('<div>').addClass('field__mirror').appendTo(self.$field);
        self.$tooltip = $('<div>').addClass('field__tooltip').appendTo(self.$field);

        self.$input
            .on('blur', function() {
                self.editor.saveFocus(self);
            })
            .on('input change keyup click blur', function() {
                self.handleCursor();
                self.render();
                self.updateCount();
            })

        self.render();
        self.updateCount();
        autosize(self.$input);

        return this;
    };


    /*
     * Renders the fields content, e. g. to highlight markup
     *
     * @returns {Field
     */
    Field.prototype.render = function() {
        var self = this;

        var text = self.$input.val();

        $.each(self.filters, function(name, filter) {
            text = text.replace(filter.pattern, function() {
                return filter.markup.apply(self, arguments);
            });
        });

        self.$mirror.html(text);
    };


    /*
     * Handles a change of the cursor position
     */
    Field.prototype.handleCursor = function() {
        var self = this;
        var selection = self.getSelection();
        var markup = self.findMarkup();
        var activeMarkup = null;
        var tooltip = false;

        // check if there are intersections between
        // the cursor position and the markup ranges
        $.each(markup, function(index, markup) {
            var min = markup.start < selection.start ? markup : selection;
            var max = markup.start < selection.start ? selection : markup;

            if(min.end > max.start) activeMarkup = markup;
        });

        if(activeMarkup) {
            tooltip = self.filters[activeMarkup.type].tooltip.apply(self, activeMarkup.matches);
        }

        if(tooltip && self.isFocussed()) {
            var text   = self.value();
            self.$mirror.html(text.substring(0, activeMarkup.start) + '<span class="field__markup--active">' + text.substring(activeMarkup.start, activeMarkup.end) + '</span>' + text.substring(activeMarkup.end, text.length));
            var $activeMarkup = self.$mirror.find('.field__markup--active');

            var pos = {
                top: $activeMarkup.offset().top - self.$field.offset().top,
                left: $activeMarkup.offset().left + .5 * $activeMarkup.width() - self.$field.offset().left,
            }

            self.$tooltip.show().text(tooltip).css({
                top: pos.top,
                left: pos.left,
            });
        } else {
            self.$tooltip.hide();
        }
    };


    /*
     *
     */
    Field.prototype.updateCount = function() {
        if(this.$count.length > 0) {
            var length = this.value().length;
            this.$count.text(length > 0 ? length : '');
        }
    }


    /*
     *
     */
    Field.prototype.findMarkup = function() {
        var markup = [];
        var text = this.value();

        $.each(this.filters, function(name, filter) {
            while((match = filter.pattern.exec(text)) !== null) {
                var matches = [];

                $.each(match, function(key, item) {
                    if(!isNaN(key)) matches.push(item);
                });

                markup.push({
                    type:  name,
                    matches: matches,
                    start: match.index,
                    end:   match.index + match[0].length,
                    length:match[0].length,
                });
            }
        });

        return markup;
    };


    /*
     * Gets the start and end position of the selection in the
     * field. If no text is selected, returns the position of the
     * character after the cursor. If the field is not active,
     * returns the position after the last character.
     *
     * @returns {Object} Object with 'start' and 'end' properties
     * representing the start end end of the selection
     */
    Field.prototype.getSelection = function() {
        var start  = this.$input.get(0).selectionStart,
            end    = this.$input.get(0).selectionEnd,
            length = this.$input.val().length;

        return {
            start: start !== undefined ? start : length,
            end:   end !== undefined ? end : length,
        };
    };


    /*
     * Inserts text at the current cursor position. If text is
     * selected, the current selection will be replaced.
     * 
     * @param {string} string The text to be inserted
     * @returns {Field}
     */
    Field.prototype.insertText = function(string) {
        var value     = this.$input.val(),
            selection = this.getSelection();

        this.value(value.substring(0, selection.start) + string + value.substring(selection.end, value.length));

        return this;
    };


    /*
     * Get/set the value of the field
     *
     * @param {String} string
     * @return {Field|String}
     */
    Field.prototype.value = function(string) {
        if(typeof string === 'string') {
            this.$input.val(string);
            this.render();
            this.updateCount();
            autosize.update(this.$input);
        } else {
            return this.$input.val();
        }
        return this;
    };


    /*
     * Set the focus on the field's dom node
     *
     * @return {Field}
     */
    Field.prototype.focus = function() {
        this.$input.focus();

        return this;
    };


    /*
     * Checks wether the field is focused
     *
     * @return {boolean}
     */
    Field.prototype.isFocussed = function() {
        return this.$input.is(':focus');
    };

    return Editor;

})(jQuery, autosize);

(function($, Editor) {

    $.fn.editor = function() {
        this.each(function() {
            var editor = new Editor($(this));
            $(this).data('editor', editor);
        });
    };

})(jQuery, Editor);