require 'active_support/concern'
module CommonFilters
  extend ActiveSupport::Concern

  included do

    def filter_release(query_relation, filter_params)
      return query_relation unless filter_params[:release]
      query_relation.where(release: filter_params[:release])
    end

    def filter_timestamp(query_relation, filter_params, timestamp_column = 'created_at')
      qr = query_relation
      qr = qr.where("#{timestamp_column} >= ?",  Time.zone.parse(filter_params[:from])) if filter_params[:from]
      qr = qr.where("#{timestamp_column} <= ?",  Time.zone.parse(filter_params[:to])) if filter_params[:to]
      qr
    end

    def from_and_to_params_are_dates(filter_params)
      begin
        Time.parse(filter_params[:from]) if filter_params[:from]
        Time.parse(filter_params[:to]) if filter_params[:to]
        true
      rescue ArgumentError
        respond_to do |format|
          format.json { render json: 'Given timestamps cannot be parsed', status: :unprocessable_entity }
        end
        false
      end
    end

  end
end
