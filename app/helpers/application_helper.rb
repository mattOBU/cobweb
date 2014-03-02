module ApplicationHelper

  def display_base_errors resource
    return '' if (resource.errors.empty?) or (resource.errors[:base].empty?)
    messages = resource.errors[:base].map { |msg| content_tag(:p, msg) }.join
    html = <<-HTML
    <div class="alert alert-error alert-block">
      <button type="button" class="close" data-dismiss="alert">&#215;</button>
      #{messages}
    </div>
    HTML
    html.html_safe
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def current_role
    role_order = %w( local_authority retrofit_provider
                  landlord community_group_administrator
                  homeowner business )
    current_user.
      roles.
      map(&:name).
      uniq.
      select { |role| role_order.include? role }.
      sort_by { |role| role_order.index(role) }.
      first
  end

  def is_business?
    current_role == 'business'
  end

  def is_homeowner?
    current_role == 'homeowner'
  end

end
