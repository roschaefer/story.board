class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session, if: proc { |c| c.request.format == 'application/json' }

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_report
  before_action :set_subnav
  before_action :authenticate_user!

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  def set_report
    if params[:report_id]
      @report = Report.find(params[:report_id])
    else
      @report = Report.current
    end
  end

  def set_subnav
    if @report
      if ['reports', 'text_components', 'triggers', 'sensors', 'events'].include?(params[:controller])
        set_subnav_items
        set_subnav_actions
      end
    end
  end

  def set_subnav_items
    reports = Report.all.map do |report|

      get_current_action = lambda do |controller|
        action = nil
        if params[:controller] == controller && ['show', 'edit', 'new'].include?(params[:action])
          action = [{
            name: params[:action].humanize.titlecase,
            active: true
          }]
        end
        action
      end

      children = []

      children += ['present', 'preview'].map do |child|
        names = {
          present: 'Live Report',
          preview: 'Preview Report'
        }

        {
          name: names[child.to_sym],
          url: url_for(controller: 'reports', action: child, report_id: report.id),
          active: params[:controller] == 'reports' && params[:action] == child
        }
      end

      children += ['text_components', 'triggers', 'sensors'].map do |child|
        {
          name: child.humanize.titlecase,
          url: url_for(controller: child, report_id: report.id),
          active: params[:controller] == child,
          children: get_current_action.call(child)
        }
      end

      children << {
        name: 'Events',
        url: events_path,
        active: params[:controller] == 'events',
        children: get_current_action.call('events')
      }

      children << {
        name: 'Report Settings',
        url: report_path(report),
        active: params[:controller] == 'reports' && ['show', 'edit'].include?(params[:action])
      }

      action = 'index'

      if params[:controller] == 'reports'
        if params[:action] == 'present' || params[:action] == 'preview'
          action = params[:action]
        elsif params[:action] == 'show'
          action = 'show'
        end
      end

      {
        name: report.name,
        url: url_for(controller: params[:controller], action: action, report_id: report.id),
        active: @report.id == report.id,
        children: children
      }

    end

    item = {
      active: true,
      children: reports
    }

    @subnav_items = []

    while item && item[:children]
      @subnav_items << item[:children]
      item = item[:children].find { |child| child[:active] }
    end

  end

  def set_subnav_actions
    actions = {}

    ['text_components', 'triggers', 'sensors'].each do |action|
      actions["create_#{action.singularize}"] = {
        controller: action,
        name: "New #{action.to_s.singularize.humanize.titlecase}",
        url: url_for(controller: action, action: 'new', report_id: @report.id)
      }
    end

    actions['create_event'] = {
      controller: 'events',
      name: 'New Event',
      url: url_for(controller: 'events', action: 'new')
    }

    if params[:controller] == 'sensors' && params[:action] == 'show'
      actions['create_sensor_reading'] = {
        controller: 'sensors',
        action: 'show',
        name: 'New Sensor Reading',
        url: url_for(controller: 'sensors', action: 'show', report_id: @report.id, anchor: 'add')
      }
    end

    primary_action = nil

    actions.each do |key, action|
      if params[:controller] == action[:controller] && (action[:action].nil? || params[:action] = action[:action])
        primary_action = key
      end
    end

    unless primary_action
      primary_action = 'create_text_component'
    end

    secondary_actions = actions.select do |key, action|
      key != primary_action
    end

    @primary_action = actions[primary_action]
    @secondary_actions = secondary_actions.values.sort_by do |action|
      params[:controller] == action[:controller] ? 0 : 1
    end

  end
end
