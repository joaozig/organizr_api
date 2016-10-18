class ListPolicy
	attr_reader :user, :list

	def initialize(user, list)
		@user = user
		@list = list
	end

	def destroy?
		owner?
	end

	private

	def owner?
		list.user == user
	end
end
