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
            sectionActive: 'form__section--active',
            openLink: 'form__section__action--open',
            nextLink: 'form__section__action--next',
            formWrapper: 'modal',
        }

        this.init();
    };


    /**
     * 
     */
    Form.prototype.init = function() {
        var $first = this.$elm.find('.' + this.cls.section).first();
        this.goToSection($first);

        var self = this;

        self.$elm.on('click', '.' + self.cls.nextLink, function(e) {
            e.preventDefault();

            $next = self.findNextSection();
            self.goToSection($next);
        });

        self.$elm.on('click', '.' + self.cls.openLink, function(e) {
            e.preventDefault();

            $section = $(this).parents('.' + self.cls.section);
            self.goToSection($section);
        });

        return this;
    };


    /**
     * @param {jQuery} $section
     */
    Form.prototype.goToSection = function($section) {
        return this.openSection($section)
    };


    /**
     * @param {jQuery} $section
     */
    Form.prototype.openSection = function($section) {
        var $active = this.findActiveSection();

        $active.removeClass(this.cls.sectionActive);
        $section.addClass(this.cls.sectionActive);

        autosize.update($section.find('textarea'));

        return this;
    };


    /**
     * @param {jQuery} $section
     */
    Form.prototype.scrollToSection = function($section) {
        var $wrapper = this.$elm.parents('.' + this.cls.formWrapper);
        var pos = $section.offset().top + $section.offsetParent().offset().top;

        $wrapper.scrollTop(pos);

        return this;
    };

    
    /**
     * 
     */
    Form.prototype.findActiveSection = function() {
        return this.$elm.find('.' + this.cls.sectionActive);
    };


    /**
     * 
     */
    Form.prototype.findNextSection = function() {
        var $active = this.findActiveSection();

        return $active.nextAll('.' + this.cls.section).first()
    };

    return Form;

})(jQuery);

(function($, Form) {

    $.fn.form = function() {
        this.each(function() {
            var form = new Form($(this));
        });
    };

    $(function() {
        $('.form').form();
    });

})(jQuery, Form);