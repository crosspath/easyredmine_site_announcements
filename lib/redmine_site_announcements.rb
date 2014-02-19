require "redmine"

module RedmineSiteAnnouncements
  class AnnouncementsHook < Redmine::Hook::ViewListener
    extend Forwardable

    # Forward certain methods to the view that called the hook.
    def_delegators :@view, :cookies, :content_tag, :render

    # Public: Renders announcement stylesheet for every request, sorta like 
    # asset pipeline would, only way crappier. This is necessary to support 
    # announcements across every view. The admin menu also relies on these 
    # styles.
    #
    # context - The Hash of context objects for the view hook.
    # 
    # Returns the stylesheet link tag as a String.
    def view_layouts_base_html_head(context = {})
      ret = ''
      unless User.current.anonymous? || context[:controller].class.name == 'AnnouncementsController'
        ret << context[:hook_caller].javascript_tag do
          a = announcements(context)
          "$(function() {
            var a = #{a.inspect};
            $(a).insertBefore('#content');
          });".html_safe
        end
      end
      ret << stylesheet_link_tag("announcements", plugin: :redmine_site_announcements)
      ret
    end

    # Public: Renders visible announcements for the current user on every
    # page. Fetches previously hidden announcements from a permanent cookie.
    #
    # context - The Hash of context objects for the view hook.
    # 
    # Returns the rendered announcements as a String.
    def announcements(context = {})
      @view = context[:hook_caller]
      @announcements = Announcement.current cookies.signed[:hidden_announcement_ids]

      content_tag :div, id: "announcements" do
        render @announcements if @announcements.any?
      end
    end
  end
end