class TextComponent < ActiveRecord::Base
  TIME_FRAMES = {
      'always' => [nil, nil].to_json,
      '(06:00 - 09:00) in the morning' => [6, 9].to_json,
      '(09:00 - 13:00) before noon' => [9, 13].to_json,
      '(13:00 - 18:00) afternoons' => [13, 18].to_json,
      '(18:00 - 23:00) evenings' => [18, 23].to_json,
      '(23:00 - 06:00) nights' => [23, 6].to_json,
  }

  attr_accessor :delete_image
  before_validation { self.image.clear if delete_image == '1' }

  # This method associates the attribute ":image" with a file attachment
  has_attached_file :image, styles: {
    small: '620>',
    big: '1000>',
  }

  validates :heading, :report, presence: true
  validates :from_hour, inclusion: { in: 0..23 }, allow_blank: true
  validates :to_hour, inclusion: { in: 0..23 }, allow_blank: true
  validate :both_hours_are_given
  has_and_belongs_to_many :triggers
  has_many :sensors, through: :triggers
  has_many :events, through: :triggers
  has_and_belongs_to_many :channels
  belongs_to :report
  belongs_to :topic
  belongs_to :assignee, class_name: 'User'
  has_many :question_answers, inverse_of: :text_component, dependent: :destroy
  accepts_nested_attributes_for :question_answers, reject_if: :all_blank, allow_destroy: true

  accepts_nested_attributes_for :triggers

  validates :channels, presence: true
  # Validate the attached image is image/jpg, image/png, etc
  validates_attachment :image, content_type: { content_type: /\Aimage\/.*\z/ }

  delegate :name, to: :topic, prefix: true, allow_nil: true
  delegate :name, to: :assignee, prefix: true, allow_nil: true

  enum publication_status: { :draft => 0, :fact_checked => 1, :published => 2 }


  def timeframe=(frame)
    arr = JSON.parse(frame)
    self.from_hour, self.to_hour = * arr
  end

  def timeframe
    [self.from_hour, self.to_hour].to_json
  end

  def active?(diary_entry)
    on_time?(diary_entry) && triggers.all? {|t| t.active?(diary_entry) }
  end

  def on_time?(diary_entry)
    result = true
    if from_day
        result &= ((report.start_date + from_day.days) <= diary_entry.moment)
    end
    if to_day
        result &= (diary_entry.moment <= (report.start_date + to_day.days))
    end

    if from_hour && to_hour
      if from_hour <= to_hour
        result &= (from_hour <= diary_entry.moment.hour ) && (diary_entry.moment.hour < to_hour)
      else
        # e.g. 21:00 -> 6:00
        result &= (diary_entry.moment.hour < to_hour ) || (from_hour <= diary_entry.moment.hour)
      end
    end
    result
  end


  def priority_index
    Trigger.priorities[priority]
  end

  def priority
    most_important_trigger = triggers.sort_by {|t| Trigger.priorities[t.priority] }.reverse.first
    most_important_trigger && most_important_trigger.priority
  end

  def css_status_class
    # These class modifiers really aren't semantic
    # and should be changed in the future

    status_css_class_mapping = {
      'draft' => 'primary',
      'fact_checked' => 'warning',
      'published' => 'success'
    }

    if status_css_class_mapping.key? publication_status
      status_css_class_mapping[publication_status]
    else
      'default'
    end
  end

  def channel_icons
    channel_icon_mapping = {
      'sensorstory' => 'fa-file-text',
      'chatbot' => 'fa-comment'
    }

    icons = []

    channels.each do |channel|
      icons.push(channel_icon_mapping[channel.name])
    end

    icons.compact
  end

  def image_url
    self.image&.url
  end

  private
  def both_hours_are_given
    if from_hour && to_hour.blank?
      errors.add(:to_hour, "is missing")
    end
    if to_hour && from_hour.blank?
      errors.add(:from_hour, "is missing")
    end
  end
end
