class StructurePolicy < ApplicationPolicy
  def initialize(user, record)
    super
    @role = user.get_role_in_space(record.space)
  end

  def update?
    @role&.can_update_space?
  end

  def destroy?
    @role&.can_delete_space?
  end

  def show?
    @role&.can_update_space?
  end
end
