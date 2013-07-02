Before('@sync') do

  #if !$has_chosen_sign_in_option
    performAction('wait_for_screen', 'AuthenticationController')
    performAction('wait_for_button', "No thanks, I'll do it later.")
    performAction('press_button_with_text', "No thanks, I'll do it later.")
    $has_chosen_sign_in_option = true
  #end
end
