module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :first, String, null: true
    field :last, String, null: true
    field :email, String, null: true
    field :phone, String, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
