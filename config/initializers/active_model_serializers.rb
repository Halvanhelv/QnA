# frozen_string_literal: true

# Keep the JSON API v1 response shape: { "questions": [...] } / { "question": {...} }
ActiveModelSerializers.config.adapter = :json
