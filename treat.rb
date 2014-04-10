require 'treat'
include Treat::Core::DSL
#Treat:Core::Installer.install 'english'
class NLP
 class << self

 	def parseDocument(location)
 		@@story = document location
 		@@story.apply(:chunk, :segment, :tokenize, :category)
 		@@story
 	end

 	def sortByPopularity
 		word_hash = {}
 		downcase_words = @@story.words.map {|word| word.to_s.downcase}.uniq
 		downcase_words.each{|word| (word_hash[word] = @@story.frequency_of word) unless word.category == 'determiner' || word.category == 'preposition'}
 		word_popularity = word_hash.sort_by {|word,count|count}.reverse
 	end

 	def dbConnection
 		Treat.databases.mongo.db = 'TreatExample'
		Treat.databases.mongo.host = 'localhost'
		Treat.databases.mongo.port = '27017'

		Treat.databases.mongo.db
 	end

 	def save
 		@@dbName ||= dbConnection
 		@@story.serialize :mongo, db: @@dbName
 	end

 	def toXML
 	 @@story.serialize :xml, file: 'output.xml'
 	end
 end
end

NLP::parseDocument '/home/keegan/Lovecraft/The Call of Cthulhu'
NLP::save