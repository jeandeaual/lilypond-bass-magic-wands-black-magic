\version "2.20.0"

\header {
  title = "Black Magic"
  composer = "Magic Wands"
  % composer = "Chris & Dexy Valentine"
  author = \markup \fromproperty #'header:composer
  subject = \markup \concat { \fromproperty #'header:title " Bass Partition" }
  source = "Rocksmith® 2014"
  keywords = #(string-join '(
    "music"
    "partition"
    "bass"
  ) ", ")
  tagline = ##f
}

#(set-global-staff-size 32)

main = #(define-music-function (count) (number?) #{
  \repeat volta #count {
    \repeat unfold 4 ais8 \repeat unfold 4 cis
    \repeat unfold 4 fis \repeat unfold 3 dis
    dis^\markup \tiny \concat { #(number->string count) "×" }
  }
#})

song = {
  \numericTimeSignature
  \tempo 4 = 116
  \time 4/4
  \key dis \minor
  \relative c, {
    \main 21
    \break
    ais8 r r4 r2
    \compressMMRests R1*4
    \break
    \main 9
    \break
    \repeat unfold 16 dis8
    ais8-> \deadNote ais ais2.
  }
}

staves = #(define-music-function (scoreOnly tabOnly) (boolean? boolean?) #{
  \new StaffGroup \with {
    instrumentName = #"Bass"
    midiInstrument = #"electric bass (finger)"
  } <<
      #(if (not tabOnly) #{
        \new Staff {
          \clef "bass_8"
          \song
        }
      #})
      #(if (not scoreOnly) #{
        \new TabStaff \with {
          stringTunings = #bass-tuning
          minimumFret = #6
          restrainOpenStrings = ##t
        } {
          \clef "moderntab"
          #(if tabOnly #{
            \tabFullNotation
            \stemDown
          #})
          \song
        }
      #})
  >>
#})

\book {
  \score {
    \staves ##f ##f
    \layout {
      \omit Voice.StringNumber
      \context {
        \Score
        \omit BarNumber
      }
    }
  }

  \score {
    \unfoldRepeats \staves ##f ##f
    \midi { }
  }
}

\book {
  \bookOutputSuffix "score-only"

  \header {
    pdftitle = \markup \concat { \fromproperty #'header:title " (Score)" }
  }

  \paper {
    markup-system-spacing.padding = #5
    system-system-spacing.padding = #8
  }

  \score {
    \staves ##t ##f
    \layout {
      \omit Voice.StringNumber
      \context {
        \Score
        \omit BarNumber
      }
    }
  }
}

\book {
  \bookOutputSuffix "tab-only"

  \header {
    pdftitle = \markup \concat { \fromproperty #'header:title " (Tablature)" }
  }

  \paper {
    markup-system-spacing.padding = #12
    system-system-spacing.padding = #8
  }

  \score {
    \staves ##f ##t
    \layout {
      \omit Voice.StringNumber
      \context {
        \Score
        \omit BarNumber
      }
    }
  }
}
