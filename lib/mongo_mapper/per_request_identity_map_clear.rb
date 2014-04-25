module MongoMapper
  class PerRequestMapClear
    def initialize(app)
      @app = app
    end

    def call(env)
      if Rails.configuration.cache_classes
        MongoMapper::Plugins::IdentityMap.clear
      else
        MongoMapper::Document.descendants.each do |m|
          m.descendants.clear if m.respond_to? :descendants
        end
        MongoMapper::Document.descendants.clear
        MongoMapper::EmbeddedDocument.descendants.clear
        MongoMapper::Plugins::IdentityMap.clear
        MongoMapper::Plugins::IdentityMap.models.clear
      end
      @app.call(env)
    end
  end
end