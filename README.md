
### live preview
https://eloquent-turing-60c6e0.netlify.app/

### Screenshots


**Desktop**

![Sick desktop preview](screenshots/desktop.png?raw=true "Desktop Preview")


**Tablet**

![tablet preview](screenshots/tablet.png?raw=true "Tablet Preview")


**Phone**

![phone preview](screenshots/phone.png?raw=true "Phone Preview")



### Technologies used
- [elm](https://elm-lang.org/)
- javascript
- [howler.js](https://howlerjs.com/)
- [elm-ui](https://github.com/mdgriffith/elm-ui)
- git
- CI/CD

# 1. Building
I know I should learn to use yarn or npm and build the project that way.
But currently, the way I do it is I just run `frontend/make.sh` and in the 'frontend/built/'
directory I run `python3 -m http.server --bind=127.0.0.1 8080` as a development server.
Whenever I make a change I run `frontend/make.sh` again and thats how I get the job done.

For an optimized build, I just run `frontend/make.sh --optimize`


***Read below if you want to know the process behind making this website***


# 2. Design process
whenever I design a project, I always design around the most important thing 
the users would be interested in.

"One party is trying to provide a product or service, the other is interested
in accquiring it. How can I make it as easy and compelling to sell that product 
to the end user?"

In this case, Sewerslvt's music was the product that she was trying to sell.
Obviously, you would probably not buy someone's music if you didn't know what
it sounded like. Do you like it? Is it to your taste?

With that in mind, I concluded being able to listen to her music on her website
was a necessary feature, along with other helpful features like providing some
contact information.


## 2.1 UX/UI challenges

The visual design process was the most dificult. Looking at her album covers, I
understood the kind of chaotic art style she was into, however this was very much
in contrast to the way I usually go about designing interfaces. Having everything
look clean and organized is usually the way to go for me.

It does sound like I'm intentionally making things dificult for myself, doesn't it?
To make the design of this website match the brand of the person I'm designing 
it for, I would have to go against the way I usually work.

But I made this deicision deliberately. I knew I could design interfaces that 
are easy to use and organized. I wanted to challenge myself and see if I could 
design something that would still be easy to use, but looked like something 
Sewerslvt would design herself.

I think I only partly succeeded in this regard. I tried to design the website 
to have this windows95 aesthetic, but still, the ui still looks too clean for 
me to consider this a true success.
Nonetheless, in the process I still think I stepped considerably out of my 
comfort zone and can now better determine what is "too unorganized" or not.

## 2.2 Programming challenges

### 2.2.1 making windows work (*almost* like windows)

So since I had in mind I would make this website have this windows95 aesthetic,
I thought instead of having a navbar and have different links for each page, I
would just make the windows bar on the bottom be the navbar, and each "page"
would just be a different program.

A way that we can address individual windows is to store a Dict mapping Id's to
window information. Then, in our view, when we create a window, we pass in the
ID that we want that window to use and then that window can send messages requesting
that the window be closed, minimized, etc.

For example:

```elm

initWindowInfo =
    { title = "placeholder"
    , isMinimized = False
    , x = 0
    , y = 0
    , width = 20
    , height = 20
    }

type alias Id = Int
type alias Model =
    { programs : Dict.Dict Id WindowInformation
    }

type alias WindowInformation =
    { title : String
    , isMinimized : Bool
    , x : Int
    , y : Int
    , width : Int
    , height : Int
    }

type Msg =
    MinimizeWindow Id

update msg model =
    case msg of
        MinimizeWindow id ->
            let
                newWindows = Dict.update id minimizeWindow model.programs
                model_ =
                    { model_
                        | programs = newWindows
                    }
            in
                ( model_, Cmd.none )

minimizeWindow maybeWindowData =
    case maybeWindowData of
        Just w ->
            { w
                | isMinimized = True
            }
        Nothing ->
            initWindowInfo

viewWindow id model =
    Html.div
        [ Html.Events.onMouseUp (MinimizeWindow id)
        ]
        []
```

This does have limitations.

One notable one would be the fact that you can't have multiple separate windows 
of the same type open. (Or you would, but they would all share the same state.
So doing something to one of them would move the other(s) too.)

If you actually wanted to make this work like windows 95, you would probably want to do the following:
- for each `windowInformation` in the dict, store a view function of what you want to render inside of that window
- then, have a view function that takes in this whole dict as parameter, and renders all of the windows in the right dimensions, with the right z indexes, and with the proper content rendered inside of them

The reason I went with the other approach is because I determined this wasn't a feature I wanted to implement.
I wasn't trying to literally replicate windows 95 in this regard and allow an arbitrary number of open windows or type of windows.
The whole goal was actually having this windows 95 theme to the website.
Spending time implementing this to work exactly like windows 95 would have probably cost more time for a feature that I didn't even want to have. This is why I architected the code the way that I did to only allow one window of a certain type open at a time.


### 2.2.2 Responsiveness
how would you keep this windows 95 theme to the website, while still making it work across mobile devices?
The solution I settled on was to simply render the windows 95 music player onto the entire viewport once the viewport was small enough.
I unfortunately didn't think of this in the beginning, so I had to refactor the music player view function considerably.


### 2.2.3 Javascript
This project uses [howler.js](https://howlerjs.com/) to play audio, so I had to use javascript to integrate it with elm.

**Pain**

# 3. Deal breakers
So is this in production? Is it actually being used?
Sadly, no.
I'll ouline below reasons as to why.


## 3.1 Song load times
I don't serve these songs from a properly written specialized music streaming server. 
I serve these songs from github. And the whole song has to get to the client before it starts playing.

When I first started working on the website, I thought this wasn't that bad, since on PC they loaded within 1-2 seconds. I didn't even expect the phone version to load as slow as it did, but just when I tried it on mine, in spite of having 4G internet, a song still took on average 10 seconds or more to load.
This is obviously unacceptable.

From here I could've gone down two paths: use a cheap hack to fix it, or write a music streaming server.

#### using the cheap hack
This project uses [howler.js](https://howlerjs.com/) to play audio. Howler.js also supports loading more audio sources at the same time, and transitioning between them.
So one idea was this:
- for each song I would have two versions: the first 20 seconds of the song, and the full version.
- when the user presses play, we send two http requests: one for the 20 second version, and one for the full version.
- the 20 second verson would obviously load more quickly, so we'd immediately start playing it upon load.
- then, once the full version would be loaded, we would stealthily transition from the 20 second version to the full version of the song and BOOM *hackerman*

Obviously this would break if the user seeked past 20 seconds in the song and then pressed play.

#### writing a proper music streaming server
I could have done this, but two things were on my mind.
1. By this point I feel like I could be just using this code myself to launch my own music streaming service.

and

2. Obviously, if this were to go into production, it would have to be tested (so would I also take the role of QA AND backend dev?), and also, it would have to be hosted somewhere. I'd have probably gone with something like AWS, but if I also learned that, by that point I'd be a fullstack engineer, and I'd be doing devops. I don't have unlimited resources, so if I did that, the project would've taken much more than 3 months to complete, so I'd either start my own company, or I'd be asking money for that sort of work. Money which I knew I wasn't going to get, since this whole project was my idea, and did it primarily as a platform for me to practice getting a frontend as close to production quality as possible.


## 3.2 The whole UI idea
I thought it sounded cool to have this look like windows95. I could've hidden a bunch of cool easter eggs in either the file explorer, the start panel, or in other places.
But I think that at the end of the day, especially if they resize their window, a user would be too overwhelmed with what's going on.
"It starts out as windows 95, but then now it's a music player?? How do I get contact information if I'm on mobile?"

Also, even though I thought it was cool for me to practice, was listening to music on this website REALLY necessary? If someone really wanted to listen to her music, they could've just gone on her bandcamp for that.

Eventually I had to be honest and ask myself: is this really a website an artist would want, or did I let it turn into "my cool code project" too much? And I think that if I'm being honest, the latter holds more weight.


