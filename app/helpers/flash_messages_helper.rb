module FlashMessagesHelper
  def bootstrap_class_for flash_type
    hash = HashWithIndifferentAccess.new({ success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" })
    hash[flash_type] || flash_type.to_s
  end

  def flash_messages(opts = {})
    html_all = ""
    flash.each do |msg_type, message|
      html = <<-HTML
    <div class="alert #{bootstrap_class_for(msg_type)} alert-dismissable"><button type="button" class="close"
    data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
      #{message}
    </div>
      HTML
      html_all += html
    end
    html_all.html_safe
  end
end
