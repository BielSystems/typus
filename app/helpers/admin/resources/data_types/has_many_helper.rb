module Admin::Resources::DataTypes::HasManyHelper

  def has_many_filter(filter)
    att_assoc = @resource.reflect_on_association(filter.to_sym)
    class_name = att_assoc.options[:class_name] || filter.classify
    resource = class_name.constantize

    items = [[Typus::I18n.t("View all %{attribute}", :attribute => @resource.human_attribute_name(filter).downcase.pluralize), ""]]
    items += resource.order(resource.typus_order_by).map { |v| [v.to_label, v.id] }
  end

  alias_method :has_and_belongs_to_many_filter, :has_many_filter

  def typus_form_has_many(field)
    setup_relationship(field)

    options = @reflection.through_reflection ? {} : { @reflection.foreign_key => @item.id }

    # This options should only be merged when there's a Polymorphic association.
    # options.merge!(:resource => @resource.model_name, :resource_id => @item.id, :resource_action => "relate")

    count_items_to_relate = @model_to_relate.order(@model_to_relate.typus_order_by).count - @item.send(field).count

    build_pagination

    # If we are on a through_reflection set the association name!
    @resource_actions = if @reflection.through_reflection
                          [["Edit", { :action => "edit", :layout => 'admin/headless' }, { :class => 'iframe' }],
                           ["Unrelate", { :resource_id => @item.id,
                                          :resource => @resource.model_name,
                                          :action => "unrelate",
                                          :association_name => @association_name},
                                        { :confirm => "Unrelate?" } ]]
                        else
                          [["Edit", { :action => "edit", :layout => 'admin/headless' }, { :class => 'iframe' }],
                           ["Trash", { :resource_id => @item.id,
                                       :resource => @resource.model_name,
                                       :action => "destroy" },
                                     { :confirm => "Trash?" } ]]
                         end

    locals = { :association_name => @association_name,
               :add_new => build_add_new_for_has_many(@model_to_relate, field, options),
               :table => build_relationship_table }

    render "admin/templates/has_many", locals
  end

  def build_add_new_for_has_many(klass, field, options = {})
    if admin_user.can?("create", klass)
      default_options = { :controller => "/admin/#{klass.to_resource}",
                          :action => "new",
                          :layout => "admin/headless" }

      link_to Typus::I18n.t("Add New"), default_options.merge(options), { :class => "iframe" }
    end
  end

end
