module Home.View.Desktop exposing (view)

import Dict
import Element as E
import Element.Background as EBackground
import Element.Border as EBorder
import Element.Font as EFont
import Html
import Html.Attributes
import Html.Events exposing (on)
import Home.Msg as Msg
import Home.View.Navbar


import Json.Decode as JD

import OBJ.Types exposing (Mesh(..), ObjFile)

import Math.Matrix4 as M4 exposing (Mat4)
import Math.Vector3 exposing (Vec3, vec3)
import Math.Vector2 as Vec2 exposing (Vec2, vec2)

import Home.Palette as Palette

import WebGL as GL
import WebGL.Settings.DepthTest as DepthTest
import WebGL.Texture exposing (Error(..), Texture)
import WebGL.Settings exposing (cullFace, front)
import Window

import Home.Shaders as Shaders

import Html

import Icons

view title model =
    { title = title
    , body = 
        [ E.layout
            [ E.inFront (Home.View.Navbar.makeNavbar model)
            ]
            <| mainDocumentColumn model
        ]
    }

mainDocumentColumn model =
    let
        postPic = "./bg.png"
        postPic2 = "./bg2.png"
        postPic3 = "./bg3.jpg"
        postPic4 = "./bg4.jpg"
    in
    E.column
        [ E.width E.fill
        -- , EBackground.color <| E.rgb255 10 20 36
        , EBackground.color <| E.rgb255 255 255 255
        -- , EFont.family
        --     -- [ EFont.typeface Palette.font1
        --     [ EFont.typeface Palette.font0
        --     ]
        -- , EFont.size 69
        -- , EFont.light
        
        -- , E.htmlAttribute <| Html.Attributes.style "width" ((String.fromInt maxWidth) ++ "px")
        -- , E.htmlAttribute Html.Attributes.style "height" ((String.fromInt imageHeight) ++ "px")
        , E.htmlAttribute <| Html.Attributes.style "background-image" ("url(" ++ postPic4 ++ ")")
        , E.htmlAttribute <| Html.Attributes.style "background-size" "cover"
        ]
        [ block0 model
        , block1 model
        , heightBlock 200
        ]

block0 model =
    let
        maxWidth = 800
        billboard = "./billboard.png"
        logo = "./logo.png"
    in
    E.column
        [ E.height <| E.px 640
        , E.width E.fill
        -- , EBackground.color <| E.rgb255 80 80 80
        , E.centerX
        , E.htmlAttribute <| Html.Attributes.style "background-image" ("url(" ++ billboard ++ ")")
        , E.htmlAttribute <| Html.Attributes.style "background-size" "cover"
        ]
        [ E.el 
            [ E.width <| E.maximum maxWidth E.fill
            -- , E.height <| E.px 800 
            , E.centerX
            , E.centerY
            ]
            <| E.image 
                [ E.width <| E.px 420
                , E.centerX
                , E.centerY
                ]
                { src = logo
                , description = ""
                }
        ]

block1 model =
    let
        imageSize = 200
        widthSpacing = 40
        heightSpacing = 40

        makeAlbum : 
            Int 
            -> { coverImage : String, title : String, maybeAuthor : Maybe String } 
            -> E.Element msg
        makeAlbum imgSize { coverImage, title, maybeAuthor } =
            E.column
                [ E.height <| E.px (imgSize + 60)
                , E.width <| E.px imgSize
                -- , EBackground.color <| E.rgb255 215 15 15
                ]
                [ E.html
                    <| Html.div
                        [ Html.Attributes.style "width" ((String.fromInt imgSize) ++ "px")
                        , Html.Attributes.style "height" ((String.fromInt imgSize) ++ "px")
                        , Html.Attributes.style "background-image" ("url(" ++ coverImage ++ ")")
                        , Html.Attributes.style "background-size" "cover"
                        ]
                        []
                , E.paragraph
                    [ E.width <| E.px imgSize
                    -- , E.htmlAttribute <| Html.Attributes.style 
                    , EFont.size 16
                    , EFont.family
                        [ EFont.typeface Palette.font1
                        ]
                    -- , EFont.color <| E.rgb255 230 80 170
                    -- , EFont.color <| E.rgb255 255 255 255
                    , EFont.color <| E.rgb255 32 20 26
                    -- , EBackground.color <| E.rgb255 10 110 10
                    ]
                    [ E.text title
                    ]
                , case maybeAuthor of
                    Just str ->
                        E.el
                            [ EFont.size 14
                            , EFont.light
                            , EFont.family
                                [ EFont.typeface "Roboto"
                                ]
                            -- , EFont.color <| E.rgb255 230 80 170
                            , EFont.color <| E.rgb255 32 20 26
                            ]
                            <| E.text str
                    Nothing ->
                        E.none
                ]
        makeAlbumSized =
            makeAlbum imageSize

        albums0 =
            [ makeAlbumSized
                { coverImage = "./albums/0.jpg"
                , title = "Draining Love Story"
                , maybeAuthor = Nothing
                }
            , makeAlbumSized
                { coverImage = "./albums/1.jpg"
                , title = "Drowning In The Sewer"
                , maybeAuthor = Nothing
                }
            , makeAlbumSized
                { coverImage = "./albums/2.jpg"
                , title = "Starving Slvts Always Get Their Fix"
                , maybeAuthor = Nothing
                }
            , makeAlbumSized
                { coverImage = "./albums/3.jpg"
                , title = "Sewer//Slvt - EP"
                , maybeAuthor = Nothing
                }
            ]
        albums1 =
            [ makeAlbumSized
                { coverImage = "./albums/4.jpg"
                , title = "Selected Sewer Works (2017-19)"
                , maybeAuthor = Nothing
                }
            , makeAlbumSized
                { coverImage = "./albums/5.jpg"
                , title = "Euphoric Filth (Cheru's Theme)"
                , maybeAuthor = Nothing
                }
            , makeAlbumSized
                { coverImage = "./albums/6.jpg"
                , title = "Kawaii Razor Blades (feat. yandere)"
                , maybeAuthor = Nothing
                }
            , makeAlbumSized
                { coverImage = "./albums/7.jpg"
                , title = "Mr. Kill Myself"
                , maybeAuthor = Nothing
                }
            ]

        albums = 
            E.column
                [ E.centerX
                    , EBackground.color <| E.rgb255  240 190 10
                ]
                [ E.row
                    [ E.spacing widthSpacing
                    ]
                    albums0
                , E.row
                    [ E.spacing widthSpacing
                    ]
                    albums1
                ]

        wholeContent =
            E.el
                [ E.width <| E.px ((imageSize * 4) + 300)
                , E.height <| E.px ((imageSize * 4))
                , E.centerX
                ]
                <| E.el
                    [ E.width E.fill
                    , E.height E.fill
                    , EBackground.color <| E.rgb255  255 200 220
                    ]
                    albums
                    -- <| E.column
                    --     [ E.centerX
                    --     ]
                    --     albums
    in
        E.column
            [ E.centerX
            ]
            [ E.el
                [ EFont.size 60
                , EFont.color <| E.rgb255 230 30 10
                , EFont.family
                    [ EFont.typeface "undefined"
                    ]
                , E.centerY
                , E.height <| E.px 240
                , E.paddingEach { top = 120, right = 0, bottom = 0, left = 0 }
                ]
                <| E.text "My music :)"
            , Window.makeWindow 
                { title = "Untitled - Notepad"
                , buttons = [ Window.makeButton Icons.xIcon ]
                , toolsList = 
                    [ Window.makeToolItem "File" 
                    , Window.makeToolItem "Edit"
                    , Window.makeToolItem "Help"
                    ]
                }
                wholeContent
            ]

heightBlock height =
    E.el
        [ E.height <| E.maximum height E.fill
        ]
        <| E.text ""
    
wannabe3d = 
    E.el
        [ E.width <| E.px 300
        , E.height <| E.px 300
        , EBackground.color <| E.rgb255 50 70 120
        ]
        <| E.text ""


----------------
-- helper code
----------------

-- threedee: Model -> Html.Html Msg
threedee model =
    E.html
        <| Html.div
            []
            [ case ( model.mesh, model.texture ) of
                ( Ok m, Ok texture ) ->
                    GL.toHtmlWith [ GL.antialias, GL.depth 1 ]
                        [ onZoom
                        , Html.Attributes.width 300
                        , Html.Attributes.height 300
                        , Html.Attributes.style "position" "absolute"
                        ]
                        (Dict.values m
                            |> List.concatMap Dict.values
                            |> List.map (renderModel model texture )
                        )

                ( Err m, _ ) ->
                    Html.div [] [ Html.text <| "ERROR with mesh: " ++ m ]

                _ ->
                    Html.div [] [ Html.text <| "Non-mesh error." ]
            ]

-- renderModel : Model -> Texture -> Texture -> Mesh -> GL.Entity
renderModel model texture mesh =
    let
        camera =
            getCamera model

        modelM =
            M4.makeTranslate (vec3 0 0 0) -- TODO!!!!! flip model if necessary

        theta =
            2 * model.time

        lightPos =
            vec3 (0.5 * cos theta) (1 + 0.5 * sin theta) 0.5

        uniforms =
            { camera = camera
            , mvMat = M4.mul camera.view modelM
            , modelViewProjectionMatrix = M4.mul camera.viewProjection modelM
            , modelMatrix = modelM
            , viewPosition = camera.position
            , texture = texture
            , lightPosition = lightPos
            }
    in
    case mesh of
        WithoutTexture { vertices, indices } ->
            renderCullFace Shaders.simpleVert Shaders.simpleFrag (GL.indexedTriangles vertices indices) uniforms

        WithTexture { vertices, indices } ->
            renderCullFace Shaders.simpleVert Shaders.simpleFrag (GL.indexedTriangles vertices indices) uniforms

        WithTextureAndTangent { vertices, indices } ->
            renderCullFace Shaders.simpleVert Shaders.simpleFrag (GL.indexedTriangles vertices indices) uniforms



-- getCamera : Model -> CameraInfo
getCamera { mouseDelta, zoom, windowSize } =
    let
        ( mx, my ) =
            ( Vec2.getX mouseDelta, Vec2.getY mouseDelta )

        aspect =
            toFloat windowSize.width / toFloat windowSize.height

        proj =
            M4.makePerspective 45 aspect 0.01 10000

        position =
            vec3 (zoom * sin -mx * sin my) (-zoom * cos my + 1) (zoom * cos -mx * sin my)

        view_ =
            M4.makeLookAt position (vec3 0 1 0) (vec3 0 1 0)
    in
    { projection = proj, view = view_, viewProjection = M4.mul proj view_, position = position }


renderCullFace : GL.Shader a u v -> GL.Shader {} u v -> GL.Mesh a -> u -> GL.Entity
renderCullFace =
    GL.entityWith [ DepthTest.default, cullFace front ]


models : List String
models =
    [ "./matthew.obj"
    ]

onZoom : Html.Attribute Msg.Msg
onZoom =
    on "wheel" (JD.map Msg.Zoom (JD.field "deltaY" JD.float))

