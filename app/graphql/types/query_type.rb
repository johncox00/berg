module Types
  class QueryType < Types::BaseObject
    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    # TODO: remove me
    field :users, UsersType, null: false do
      description "get a paginated list of users"
      argument :page, Int, required: false
      argument :per, Int, required: false
    end

    def users(page=1, per=10)
      User.all.page(page).per(per)
    end
  end
end
