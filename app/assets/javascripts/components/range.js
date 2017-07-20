/**
 * RANGE
 */

var Range = (function($, multirange) {
   
    function Range($elm) {
        this.$elm = $elm;

        this.$fallback = $elm.find('.range__fallback');

        this.$min = $elm.find('.range__hidden--min');
        this.$max = $elm.find('.range__hidden--max');

        this.$input = null;
        this.$tooltipLow = null;
        this.$tooltipHigh = null;

        this.options = {
            min: this.$elm.data('min') || 0,
            max: this.$elm.data('max') || 100,
            step: this.$elm.data('step') || 1,
            value: [this.$min.val() || 0, this.$max.val() || 100].sort(),
        }

        this.init();

        return this;
    }

    Range.prototype.init = function() {
        var self = this;

        // hide default min/max inputs
        self.$fallback.hide();

        // create range min/max info elements
        $infoMin = $('<span>').addClass('range__info range__info--min').text(self.options.min);
        $infoMax = $('<span>').addClass('range__info range__info--max').text(self.options.max);

        // create new range slider element
        var $input = $('<input>').attr({
            class: 'range__input',
            type: 'range',
            multiple: true,

            min: self.options.min,
            max: self.options.max,
            step: self.options.step,
            value: self.options.value.join(',')
        });


        // create value tooltips
        var $tooltipLow = $('<div>').addClass('range__tooltip');
        var $tooltipHigh = $('<div>').addClass('range__tooltip');

        self.$elm.append($input, $infoMin, $infoMax, $tooltipLow, $tooltipHigh);

        self.$input = self.$elm.find('.range__input');
        self.$tooltipLow = $tooltipLow;
        self.$tooltipHigh = $tooltipHigh;

        multirange(self.$input[0]);

        // set event handlers
        self.$elm.find('.range__input').on('input change', function() {
            self.value(self.value());
        });

        self.handleChange();

        return this;
    }

    Range.prototype.handleChange = function() {
        var self = this;

        var low = parseInt(self.value().split(',')[0]);
        var high = parseInt(self.value().split(',')[1]);

        var lowLeft = 1 - (self.options.max - low) / (self.options.max - self.options.min);
        var highLeft = 1 - (self.options.max - high) / (self.options.max - self.options.min);

        var rangeThumb = 8;

        self.$tooltipLow.css({
            'left': lowLeft * 100 + '%',
            'marginLeft' : (lowLeft - .5) / -.5 * rangeThumb,
        }).text(low);
        self.$tooltipHigh.css({
            'left': highLeft * 100 + '%',
            'marginLeft' : (highLeft - .5) / -.5 * rangeThumb,

        }).text(high);
    }

    Range.prototype.value = function(value) {
        var self = this;

        if(value) {
            // update hidden inputs
            self.$min.val(value.split(',')[0]);
            self.$max.val(value.split(',')[1]);

            // set the range input
            self.$input.val(value);

            self.handleChange();
        } else {
            return self.$input.val();
        }
    }

    return Range;

})(jQuery, multirange);

(function($, Range) {

    $.fn.range = function() {
        this.each(function() {
            var range = new Range($(this));
        });
    };

})(jQuery, Range);