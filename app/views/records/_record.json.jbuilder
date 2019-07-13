json.extract! record, :id, :name, :imm_type, :priority_date, :approval_date, :created_at, :updated_at
json.url record_url(record, format: :json)
