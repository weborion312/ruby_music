namespace :opjam do
  desc "Generate generate terms and conditions for testing"
  task :terms_and_conditions => :environment do

    unless tc = TermsAndConditions.find_by_notes("Test Terms and Conditions")
      tc = TermsAndConditions.new
      tc.active = "1"
      tc.notes = "Test Terms and Conditions"
      tc.content = "
          <ul>
            <li>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris sollicitudin erat sed ligula viverra ut fringilla diam suscipit.&nbsp;</li>
            <li>Curabitur nec est lorem, ut auctor justo. Integer accumsan leo non metus imperdiet nec tincidunt dolor varius.</li>
            <li>&nbsp;Aenean ligula sapien, porttitor ut blandit eu, dapibus ac erat. Curabitur lacinia ipsum ut nulla malesuada sit amet rhoncus mi cursus.&nbsp;</li>
            <li>Nam porta sapien vitae metus hendrerit at ornare lectus semper. Proin pulvinar porta tristique.</li>
          </ul>
          <p>Aenean semper vulputate sapien vel pharetra. Fusce et tellus ipsum. Nulla ultricies sem quis enim tincidunt faucibus. In mattis aliquet turpis, id consequat erat congue eu. Nulla facilisi. Nullam euismod nisl et erat viverra consequat. Proin pretium tellus vel ligula interdum in molestie lorem tincidunt.</p>
          <p>Praesent nec risus a arcu tincidunt euismod. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus quis dui leo, condimentum fermentum est. Suspendisse volutpat pretium ultricies. Etiam vestibulum suscipit faucibus. Nunc id mi orci, sit amet lobortis velit. Integer aliquet magna sit amet neque aliquam elementum. Etiam non risus nunc, quis sagittis velit. Suspendisse auctor auctor sem non dapibus. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Pellentesque venenatis mollis aliquet. Mauris sodales lacinia condimentum.</p>
          <ol>
            <li>Vestibulum pretium aliquet felis, id fermentum arcu varius vitae. Fusce elementum sem sit amet odio imperdiet posuere. Aliquam in nisl molestie ligula sagittis volutpat sit amet porta odio. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Quisque aliquam rutrum sollicitudin. Sed hendrerit malesuada velit, ac accumsan lectus auctor quis. Nam volutpat pellentesque commodo.</li>
            <li>Vestibulum mi est, aliquet sit amet sagittis in, sollicitudin vitae urna. In hac habitasse platea dictumst. Sed sed eros ullamcorper mi sodales ornare eget ac dolor. Mauris sem ante, imperdiet sed hendrerit eget, fringilla et est. Sed iaculis justo sed ante pretium congue. Vestibulum augue arcu, sollicitudin non sollicitudin eu, auctor sit amet nisi. Vivamus urna neque, posuere in semper sed, pellentesque volutpat urna.</li>
            <li>Vivamus turpis justo, molestie sit amet convallis a, viverra nec arcu. Sed mattis consequat fermentum. Phasellus quis eros quam, non condimentum urna. Duis lobortis risus ut nisi porttitor viverra. Donec nec sapien justo. Suspendisse potenti. Phasellus viverra dolor varius arcu mattis sed bibendum tortor eleifend. Sed ut posuere arcu. Duis nibh purus, auctor in malesuada faucibus, molestie mollis purus. Nunc id viverra diam.</li>
          </ol>
          <p>Donec sit amet tincidunt ante. Sed sagittis tempor ligula et porta. Mauris in molestie sapien. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed tincidunt placerat nisl elementum suscipit. Curabitur mi ipsum, porttitor ac iaculis eget, dignissim vitae ipsum. Duis semper lobortis libero, eget posuere augue egestas a. Maecenas enim sem, vulputate sit amet auctor id, imperdiet eget turpis. Duis lectus nunc, vestibulum non consectetur quis, mattis in lacus. Sed est nunc, accumsan id mollis vel, gravida nec ligula. Praesent consectetur metus eu diam feugiat sed sodales arcu condimentum. In hac habitasse platea dictumst. Quisque vitae neque et lacus ultricies vulputate at ut magna.</p>
          <p>Proin eget leo nec est tincidunt convallis nec ac velit. Fusce sodales lorem eget quam feugiat fermentum. Etiam gravida, libero in dapibus accumsan, sapien risus iaculis ipsum, malesuada mollis turpis lectus eu libero. Fusce lectus arcu, varius vel feugiat sed, rutrum auctor nibh. Morbi sed cursus mauris. In hac habitasse platea dictumst. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus commodo fringilla dui, tincidunt iaculis lacus suscipit ut. Quisque aliquet, arcu non ultricies malesuada, velit nulla pulvinar nulla, a blandit enim turpis vel lectus. Etiam varius consectetur facilisis.</p>
          <p>In id lorem ac orci iaculis ullamcorper eget non arcu. Suspendisse mollis interdum mollis. Nunc in arcu sit amet arcu adipiscing pulvinar. Suspendisse potenti. Sed sed metus massa. Maecenas nec mattis orci. Morbi eu tellus ut orci posuere posuere ac sit amet sapien. Phasellus eu erat in mauris porta volutpat. Integer ultrices odio mattis massa auctor aliquam. Nullam id lectus arcu, vel suscipit nisl. Suspendisse dignissim fringilla leo ut ultricies.</p>
          <p>Ut consectetur aliquet nulla eget porttitor. Integer id erat quam, a tristique mauris. Maecenas in urna sit amet tortor dictum vulputate. Vestibulum ut justo ac mauris aliquet luctus id ut elit. Nam feugiat, quam a facilisis mattis, orci neque consequat metus, non ullamcorper diam leo sed lectus. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nulla facilisi. Quisque a nisl sapien, a scelerisque ante. Aliquam erat volutpat. Vivamus sit amet leo eu ligula interdum tristique a in metus. Aliquam dapibus erat quis dolor viverra ultricies.</p>
          <p style='text-align: center;'><span style='font-family: 'arial black', 'avant garde'; color: #808080; background-color: #e5e5e5;'>Copyright @ OpJam</span></p>
        "
        tc.save!
        puts "Test Terms and Conditions with Version #{tc.id} have been saved!\n"
    else
      puts "You already have 'Test Terms and Conditions' in database!"
    end
  end

  desc "destroy test Terms and Conditions"
  task :destroy_terms_and_conditions => :environment do
    if tc = TermsAndConditions.find_by_notes("Test Terms and Conditions")
      tc.destroy
      puts "Test Terms and Conditions destroyed!\n"
    else
      puts "Nothing to do!"
    end
  end
end
