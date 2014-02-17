class ProjectApplication < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  before_create :set_status


  private

  def set_status
    self.status = 'pending' unless status
  end
end
