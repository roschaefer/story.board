/**
 * FORM
 */

var Form = (function($) {

    /**
     * Creates an instance of the Form class
     *
     * @constructor
     * @param {jQuery} $form
     */
    function Form($form) {

        this.$elm = $form;

        this.cls = {
            section: 'form__section',
            sectionDefault: 'form__section--default',
        }

        this.init();
    };


    /**
     * 
     */
    Form.prototype.init = function() {
        if(window.location.hash === '') {
            window.location.hash = this.findDefaultSection().attr('id');
        }        

        return this;
    };

    
    /**
     * 
     */
    Form.prototype.findDefaultSection = function() {
        return this.$elm.find('.' + this.cls.sectionDefault);
    };

    return Form;

})(jQuery);

(function($, Form) {

    $.fn.form = function() {
        this.each(function() {
            var form = new Form($(this));
        });
    };
})(jQuery, Form);
