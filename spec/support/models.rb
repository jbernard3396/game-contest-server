def expect_required_attribute(attribute)
  assignment = (attribute.to_s + '=').to_sym
  subject.send(assignment, nil)

  should_not be_valid
end


def puts_players(players)
	players.each do |p|
		puts p.name
	end
end
