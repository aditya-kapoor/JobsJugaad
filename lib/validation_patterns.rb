module ValidationPatterns

  PATTERNS = {
    'email' => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
    'website' => /\A(https?:\/\/)?((([A-z]+)\.)*)([A-z]+\.[A-z]{2,4})\Z/,
    'photo' => %r{[.](jpg|jpeg|png|ico|gif)\Z}i,
    'resume' => %r{[.](pdf|docx|doc|txt)$}i
  }

end