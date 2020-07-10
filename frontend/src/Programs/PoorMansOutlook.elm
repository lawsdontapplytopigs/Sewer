module Programs.PoorMansOutlook exposing
    ( PoorMansOutlookData
    , init
    , updateEmail
    , updateSubject
    , updateContent
    )

type alias Email = String -- TODO: not every string is a valid email address

type alias PoorMansOutlookData =
    { from : Email
    , subject : String
    , content : String
    }

init : PoorMansOutlookData
init =
    { from = ""
    , subject = ""
    , content = ""
    }

updateEmail : String -> PoorMansOutlookData -> PoorMansOutlookData
updateEmail str data =
    { data
        | from = str
    }

updateSubject : String -> PoorMansOutlookData -> PoorMansOutlookData
updateSubject str data =
    { data
        | subject = str
    }

updateContent : String -> PoorMansOutlookData -> PoorMansOutlookData
updateContent str data =
    { data
        | content = str
    }
