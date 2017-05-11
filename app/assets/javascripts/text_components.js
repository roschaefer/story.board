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
        this.$editor  = $editor;
        this.$toolbar = $editor.find('.text-editor__toolbar:first');
        this.$fields  = $editor.find('.text-editor__field');

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

        // Prevent loosing focus when clicking toolbar buttons
        self.$toolbar.on('mousedown', function(e) {
            e.preventDefault();
        });

        self.$toolbar.find('[data-editor-markup-command]').on('click', function(e) {
            e.preventDefault();

            var command = self.commands[$(this).data().editorMarkupCommand];

            if(typeof command !== 'function') throw new Error('Command not defined: ' + $(this).data().editorMarkupCommand);
            
            self.insertText(command($(this)));
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
        var $activeField = $(':input:focus:first', this.$editor);

        if($activeField.length > 0) {
            var field = new Field($activeField);
            field.insertText(string);
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
        this.$field = $field;

        this.editor = editor;
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
    });

})(jQuery, Editor);