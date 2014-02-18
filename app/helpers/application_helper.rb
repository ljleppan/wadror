module ApplicationHelper
  def edit_and_destroy_buttons(item)
    unless current_user.nil?
      edit = link_to('Edit', url_for([:edit, item]))
      del = link_to('Destroy', item, method: :delete, data: {confirm: 'Are you sure?' })
      raw("#{edit} #{del}")
    end
  end

  def round(num)
    if num.nil?
      '-'
    else
      '%0.1f' % num
    end
  end
end