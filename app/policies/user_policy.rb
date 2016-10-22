class UserPolicy
	attr_reader :current_user, :user

	def initialize(current_user, user)
		@current_user = current_user
		@user = user
	end

	def show?
		self?
	end

	def update?
		self?
	end

	private

	def self?
		current_user.id == user.id
	end
end
