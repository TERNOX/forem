module Badges
  class AwardStreak
    LONGEST_STREAK_WEEKS = 16

    MINIMUM_QUALITY = -25

    def self.call(weeks:)
      new(weeks: weeks).call
    end

    def initialize(weeks:)
      @weeks = weeks
    end

    def call
      badge_slug = "d0-a5-d0-b2-d0-b8-d0-bb-d1-8f-d1-82-d0-b2-d0-be-d1-80-d1-87-d0-be-d1-81-d1-82-d1-96-28-d0-a2-d0-b8-d0-b6-d0-bd-d1-96-3a-#{weeks}-29"
      return unless (badge_id = Badge.id_for_slug(badge_slug))

      users = User.where(id: article_user_ids).where("articles_count >= ?", weeks)

      users.find_each do |user|
        count = weeks.times.count { |i| published_x_weeks_ago?(user, i + 1) }
        next unless count >= weeks

        user.badge_achievements.create(
          badge_id: badge_id,
          rewarding_context_message_markdown: generate_message,
        )
      end
    end

    private

    attr_reader :weeks

    # No credit for super low quality
    def article_user_ids
      Article.published
        .where("published_at > ? AND score > ?", 1.week.ago, MINIMUM_QUALITY)
        .pluck(:user_id)
    end

    def published_x_weeks_ago?(user, num)
      user.articles.published
        .where("published_at > ? AND published_at < ?", num.weeks.ago, (num - 1).weeks.ago).any?
    end

    def generate_message
      return I18n.t("services.badges.award_streak.longest") if weeks == LONGEST_STREAK_WEEKS

      I18n.t("services.badges.award_streak.message", count: weeks * 2)
    end
  end
end
