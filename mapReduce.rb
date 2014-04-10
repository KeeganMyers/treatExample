require 'mongoid'
#include Mongoid::Document
KLASS = "this._type"
#SECTION = "this.section"


Mongoid.load! "mongo.yml", :development
@session = Moped::Session.new(["127.0.0.1:27017"])
@session.use :TreatExample


def count_by(type)
  map = <<EOF
    function() {
      function truthy(value) {
        return (value == true) ? 1 : 0;
      }
      emit(#{type}, {type: #{type}, count: 1, word: this.value})
    }
EOF

  reduce = <<EOF
    function(key, values) {
      var count = 0; word = 0;
      values.forEach(function(doc) {
        count += parseInt(doc.count);
        word += parseInt(doc.word);
        type = doc.type
      );
      return {type: type, count: count, word: word}
    }
EOF

  #collection.mapreduce(map, reduce).find()
  puts @session.command(
	mapreduce: "values",
	map: map,
	reduce: reduce,
	out: { inline: 1 }
  )
end

count_by "the"