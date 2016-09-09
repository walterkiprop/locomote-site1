module Locomotive::Steam
  module Adapters
    module MongoDB

      class Command

        def initialize(collection, mapper)
          @collection = collection
          @mapper     = mapper
        end

        def insert(entity)
          # make sure the entity gets a valid id
          entity[:_id] ||= BSON::ObjectId.new

          serialized_entity = @mapper.serialize(entity)

          @collection.insert_one(serialized_entity)

          entity
        end

        def inc(entity, attribute, amount = 1)
          entity.tap do
            @collection.find(_id: entity._id).update_one('$inc' => { attribute => amount })
            entity[attribute] ||= 0
            entity[attribute] += amount
          end
        end

        def delete(entity)
          @collection.find(_id: entity._id).delete_one if entity._id
        end

      end

    end
  end
end
