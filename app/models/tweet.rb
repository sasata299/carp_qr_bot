class Tweet
  attr_reader :data_id, :inning, :name, :detail, :score

  def initialize(score_report)
    @data_id = score_report['id']
    @inning = score_report['inning']
    @name = score_report['name']
    @detail = score_report['detail']
    @score = score_report['score']
  end

  def status
    if name.present?
      "【#{inning}】【#{score}】#{name}が#{detail}"
    else
      "【#{inning}】【#{score}】#{detail}"
    end
  end
end
