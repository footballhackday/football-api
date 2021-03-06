class TeamParser
  def initialize(content)
    @parser = Nokogiri::XML(content)
  end

  def created_at
    DateParser.new(root).date
  end

  def version
    root.xpath('version').first['number']
  end

  def league
    convert(league_node)
  end

  def season
    convert(season_node)
  end

  def teams
    team_nodes.map { |team_node| convert(team_node) }
  end

  private

  def root
    @parser.xpath('//sports-statistics/sports-teams').first
  end

  def team_nodes
    root.xpath('ifb-soccer-teams/team-info')
  end

  def league_node
    root.xpath('league').first
  end

  def season_node
    root.xpath('season').first
  end

  def convert(node)
    node.to_h.map { |key, value| [key.gsub('-', '_'), value] }.to_h.with_indifferent_access
  end
end
