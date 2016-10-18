class ListPolicy
	attr_reader :user, :list

	def initialize(user, list)
		@user = user
		@list = list
	end

	def update?
		owner?
	end

	def destroy?
		owner?
	end

	private

	def owner?
		list.user.id == user.id
	end
end
