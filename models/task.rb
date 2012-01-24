class Task
  include MongoMapper::Document

  key :name,        String  # event name
  key :description, String  # extended info
  key :time,        Time    # event time
  key :length,      Integer # in seconds
end