# frozen_string_literal: true

class Redis::AbstractModels
  private

  def models
    raise "Must define models"
  end

  def key
    raise "Must define key"
  end

  def attrs
    {}
  end

  def columns
    nil
  end

  def expiry
    -1
  end

  def get
    data = REDIS.get key
    unless data.present?
      data_from_db = models_with_select.where(attrs)&.first
      return nil unless data_from_db.present?

      data = columns.present? ? data_from_db.attributes.to_json : data_from_db.to_json
      REDIS.set key, data, nx: true, ex: expiry
    end

    cache_data = ActiveSupport::JSON.decode(data)
    datas = cache_data.slice(*models.column_names)

    models.new datas
  end

  def set
    REDIS.set key, attrs, ex: expiry
  end

  def del
    REDIS.del key
  end

  def models_with_select
    columns.present? ? models.select(columns) : models
  end
end
