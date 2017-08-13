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
      qr = qr.where("#{timestamp_column} >= ?",  filter_params[:from]) if filter_params[:from]
      qr = qr.where("#{timestamp_column} <= ?",  filter_params[:to]) if filter_params[:to]
      qr
    end
  end
end
