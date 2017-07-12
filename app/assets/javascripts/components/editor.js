/*
 * Place all the behaviors and hooks related to the matching controller here.
 * All this logic will automatically be available in application.js.
 */

var Editor = (function($) {

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
        var $field = this.$editor.find(this.options.selector.field + ':focus');

        if($field.length > 0) {
            return $field.data('editorField');
        } else {
            return null;
        }
    }

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
    }

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
    }

    /*
     * Creates an instance of the Field class
     *
     * @constructor
     * @param {jQuery} $field The field element
     * @param {Editor} editor The editor the field belongs to
     */
    function Field($field, editor) {
        this.$field = $field;
        this.editor = editor;

        this.init();
    };


    /*
     * Initiate the field's dom node
     *
     * @return {Field}
     */
    Field.prototype.init = function() {
        var self = this;

        self.$field.on('blur', function() {
            self.editor.saveFocus(self);
        });

        return this;
    }


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
        var start  = this.$field.get(0).selectionStart,
            end    = this.$field.get(0).selectionEnd,
            length = this.$field.val().length;

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
        var value     = this.$field.val(),
            selection = this.getSelection();

        this.$field.val(value.substring(0, selection.start) + string + value.substring(selection.end, value.length));

        return this;
    };

    /*
     * Set the focus on the field's dom node
     *
     * @return {Field}
     */
    Field.prototype.focus = function() {
        this.$field.focus();

        return this;
    }

    return Editor;

})(jQuery);

(function($, Editor) {

    $.fn.editor = function() {
        this.each(function() {
            var editor = new Editor($(this));
        });
    };

    $(function() {
        $('.modal .text-editor').editor();

        $('.qa').on('cocoon:before-insert', function(e, item) {
            $(item).find('.text-editor').editor();
        });
    });

})(jQuery, Editor);