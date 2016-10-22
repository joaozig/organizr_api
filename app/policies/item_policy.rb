class ItemPolicy
	attr_reader :user, :item

	def initialize(user, item)
		@user = user
		@item = item
	end

	def update?
		owner?
	end

	def destroy?
		owner?
	end

	private

	def owner?
		item.list.user.id == user.id
	end
end
