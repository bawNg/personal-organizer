class Task
  include MongoMapper::Document

  key :name,        String  # event name
  key :description, String  # extended info
  key :starts_at,   Time    # event time
  key :length,      Integer # length in seconds
  key :due_at,      Time    # or due time
end