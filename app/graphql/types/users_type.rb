module Types
  class UsersType < Types::BaseObject
    field :results, [Types::UserType], null: true
    field :total_pages, Integer, null: true
    field :total_count, Integer, null: true
    field :current_page, Integer, null: true

    def results(page=1, per=20)
      User.all.page(page).per(per)
    end
  end
end
