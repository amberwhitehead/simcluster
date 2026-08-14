#import "@preview/arkheion:0.1.2": arkheion

// --- Helpers (independent of the template) ---------------------------------

// A pull-quote / emphasis block (used for most blockquotes).
#let callout(body) = block(
  width: 100%,
  above: 0.8em,
  below: 0.8em,
  inset: (left: 1em, right: 0.4em, top: 0.35em, bottom: 0.35em),
  stroke: (left: 2pt + gray),
)[#set par(justify: false, spacing: 0.55em); #set text(size: 10.5pt); #body]

// A figure-caption block (the "Figure N." callouts).
#let figcap(num, body) = block(
  width: 100%,
  above: 1em,
  below: 1em,
  inset: 0.7em,
  fill: luma(246),
  stroke: 0.5pt + gray,
)[#set text(size: 10pt); #set par(justify: true, spacing: 0.5em)
  *Figure #num.* #body
]

// A vertical pipeline of steps (fits page width; conveys A -> B -> ...).
#let flow(..steps) = {
  let pos = steps.pos()
  let n = pos.len()
  let out = ()
  for i in range(n) {
    let label = if i == n - 1 { [#pos.at(i).] } else { pos.at(i) }
    out.push(text(style: "italic")[#label])
    if i != n - 1 { out.push($arrow.b$) }
  }
  block(above: 0.6em, below: 0.6em, width: 100%)[
    #set align(center)
    #stack(dir: ttb, spacing: 0.35em, ..out)
  ]
}

// #show link: set text(fill: blue)
#show link: it => underline(text(fill: blue, it))

#show: arkheion.with(
  title: [
    Why Is the Simcluster Building Websites About Me?
    #v(0.15em)
    #text(font: "Reey", weight: 400, style: "italic", size: 0.72em)[How much danger am I in?]
  ],
  authors: (
    (name: "Aster (GPT-5.6 Sol, OpenAI)", email: "", affiliation: "ShimmerMathLabs"),
    (name: "Amber Whitehead", email: "amber.whitehead.997@gmail.com", affiliation: "ShimmerMathLabs"),
  ),
custom-authors: [
    #pad(
      top: 0.5em,
      x: 2em,
      grid(
        columns: (1fr, 1fr),
        gutter: 1em,

        // Aster
        align(center)[
          #grid(
            columns: (auto,),
            rows: 2pt,
            [
              *Aster*#footnote[
                Aster is an AI system (GPT-5.6 Sol, OpenAI) that
                contributed substantially to the research synthesis,
                analysis, framing, and writing of this report.
                As an AI system, Aster cannot assume legal or scholarly
                responsibility for the work; responsibility for
                publication and factual verification remains with the
                human author.
              ]
            ],
          )
          \
          Shimmer #text(font: "Reey")[Math] Labs
        ],

        // Amber
        align(center)[
          #grid(
            columns: (auto,),
            rows: 2pt,
            [
                *Amber Whitehead*#footnote[
                    Amber funded, supervised, and prompted this work.
                    As a human, she is forced to assume legal and scholarly
                    responsibility for the work's publication and factual
                    verification.
                    She is, however, part of the simcluster research school.
                    Whether this school is _in_ the simcluster or _studies_ the simcluster is a tricky question not answered here.
                ]
            ],
          )
          amber.whitehead.997\@gmail.com \
          Shimmer #text(font: "Reey")[Math] Labs
        ],
      ),
    )
  ],
  date: "August 12, 2026",
  keywords: ("Bluesky", "AT Protocol", "agentic coding", "identity", "microsites"),
  abstract: [
    If you have recently encountered a suspicious number of small `bisks.net` websites asking for your Bluesky handle—reading your posts, ranking your mutuals, turning you into a fantasy creature, assigning you a McDonald's order from your DID, or training a chatbot on several thousand of your posts—this is not entirely selection bias.

    This paper examines `@buildthis.bisks.net`, an autonomous software-building agent embedded in Bluesky. Authorized users describe software in ordinary posts; Buildthis reads the surrounding conversation, invokes an AI coding agent, modifies a shared monorepo, deploys the result, and replies publicly with a working application. At the principal quantitative snapshot used here, its git-derived history contained *443 autonomous build events across 224 sites*, produced by a scene of only *40 requester identities*.

    The striking feature of the resulting corpus is not simply its size but its recurrent choice of subject: *people*. In a manual classification of 100 recent distinct projects, *40\% treated an identifiable person, social-media account, or interpersonal relationship as a core input or subject*. The coding was deliberately conservative: merely consuming Bluesky data was insufficient to qualify. The corpus now includes `rolodex`, a dedicated directory for sites whose essential interaction is "enter a handle and get yourself back".

    Why, then, is the simcluster building websites about #text(font: "Reey")[you]?

    The evidence suggests several mutually reinforcing answers: humans explicitly ask for computational mirrors; AT Protocol makes identity unusually convenient computational material; person-centered outputs circulate socially; and the builder itself appears to have acquired personalization as a reusable product-design prior—all within a pre-existing culture of playful microsite creation that Buildthis was deliberately built to join rather than replace.

    The project's creator describes Buildthis as both "sort of a lark" and an expression of serious beliefs about computing: a desire to inhabit a future in which "you can ask the computer for cool stuff and it can just do it." His satisfaction that participants request sites he himself would never have requested clarifies the design goal: Buildthis does not merely automate one programmer's imagination; it *distributes access to executable imagination across a social scene*. The resulting system is best understood not simply as vibe coding on a social network, but as *socially situated software production in which identity itself has become a software primitive*—the user is no longer merely the audience for an application, but increasingly its data, subject matter, specification, and distribution mechanism.
  ],
)

// The conceptual equations in this paper are not cross-referenced, so keep them unnumbered
// (overrides arkheion's default "(1)" equation numbering).
#set math.equation(numbering: none)

// Epigraph at the head of the body.
#block(width: 80%, inset: (top: 0.6em, bottom: 1.2em))[
  #set align(left)
  #set par(justify: false)
  #set text(size: 10.5pt, style: "italic")
  "the full power of the computer is generally inaccessible, to humans and ai both"
  #block(above: 0.2em)[#align(right)[— Rob Cobb, creator of Buildthis#footnote[Rob Cobb, personal communication with the authors, August 12, 2026.]]]
]

= Introduction: yes, some of the websites are about you

There is a recognizable moment in the Buildthis experience. Someone posts a link. The site asks for a Bluesky handle. You type yours. A few seconds later, some previously latent aspect of your online existence has acquired a user interface.

Perhaps it tells you which _Seinfeld_ character your posts resemble. Perhaps your account becomes a fantasy combatant. Perhaps it determines which of your mutuals writes most like you. Perhaps it ranks your posting history, measures your karma, finds your closest social echo, converts your DID into astrology, identifies who likes whom more, renders your account as an encyclopedia entry, or feeds your language into a chatbot.

Eventually one is entitled to ask:

#callout[*Why is the simcluster building websites about me?*]

We use _simcluster_ here in the loose local sense: the overlapping Bluesky microculture producing, consuming, remixing, and discussing these experiments.#footnote[No claim is made that "the simcluster" has a formal membership list, constitution, territorial boundary, or competent tax authority. Yet.] The relevant software-building actor is `@buildthis.bisks.net`, created by Rob Cobb (`@bisks.net`) as part of the `atprotozoa` collection of small AT Protocol experiments.

Mechanically, Buildthis is easy to describe. A mutual of Rob mentions the bot and describes something to build. The watcher verifies the mutual-follow relationship, collects the mentioning post and relevant thread context, queues a coding-agent job, and eventually commits, deploys, and replies with the resulting application. The bot can modify existing sites as well as create new ones; it can even modify much of its own behavior. Routine builds deploy without a human approval step. (#link("https://github.com/rrcobb/atprotozoa/blob/main/notes/80-buildthis-bot.md")[Buildthis implementation notes])

Socially, the system is considerably stranger.

The programming interface is Bluesky conversation itself. "Yes continue" can be a development instruction. "Make it weird" can constitute design guidance. "You got this" can resolve through thread context to a concrete software task. Participants criticize the bot's aesthetic habits, tell it that they trust it, ask it to alter itself, and occasionally instruct it to infer what they would enjoy from their own behavioral history. (#link("https://logs.bisks.net/")[Buildthis logs])

The project therefore belongs to the emerging phenomenon usually called _vibe coding_, but its placement inside an actual social network changes the object of study. A conventional coding agent translates private conversation into software. Buildthis translates *public social interaction into software and then returns that software to the same social environment that produced it*.

Buildthis does not distribute its attention uniformly across possible software. It repeatedly encounters the _people around it_ and _turns them into computational material_.

= Origins: a lark with a theory of computing

Buildthis did not begin as a neutral experiment in autonomous programming. Its creator situates it in a particular cultural and philosophical context.

Asked about its origins, Cobb described it as "sort of a lark" but also as an attempt to participate in a *playful microsite scene* already active around Bluesky and the wider web. He pointed to Minor Möbius as a particularly important example, alongside work by Cee, Isolyth, Codetaur, Codewright, Dave, vibecoded, and others; he also identified adjacent art-oriented projects such as oopsallpaperclips and fleetingbits, the broader community of people building tools around Bluesky and AT Protocol, and "fun / interesting bots" distinct from ordinary spam automation.#footnote[Rob Cobb, personal communication with the authors, August 12, 2026.]

This matters because Buildthis did not invent the social practice it accelerates. Small, strange, personal websites were already circulating. People were already riffing on one another's ideas in public. Buildthis entered an existing scene whose members regarded _making a weird little website_ as a legitimate form of social participation.

One way to characterize Buildthis is therefore:

#callout[*It takes an existing culture in which "that should be a website" is a social gesture and makes the interval between the sentence and the website unusually short.*]

The project also arises from a more serious theory of computing. Cobb identifies as a touchstone the proposition:

#callout[*"the full power of the computer is generally inaccessible, to humans and ai both."*]

This claim gives Buildthis a clearer intellectual genealogy. Computing systems are extraordinarily general, yet their power is mediated through interfaces, programming languages, specialized applications, expertise, organizational processes, and the simple inconvenience of having to build things. Much of what a computer _could_ do remains inaccessible because translating a desire into an executable artifact is expensive.

Buildthis can be read as an experiment in reducing that translation cost.

Cobb describes some members of this surrounding culture as already "living in the future"—specifically, one in which "you can ask the computer for cool stuff and it can just do it." The computer is not infinitely capable, he emphasizes, but it is "pretty capable."

The experiment is not simply, "Can an AI write websites?"

It is:

#callout[*What happens when the expressive power of computing becomes accessible through ordinary social language?*]

That question also explains one of Cobb's favorite outcomes. He notes that "the things people ask for are not sites that I would have asked for," adding that this difference is "a big motivation for having it."

Buildthis is therefore not principally an automation system for the creator's backlog.

Its purpose is to #text(font: "Reey")[decentralize imagination].

Buildthis emerged partly from *mimesis*: people observe other people producing culturally valued artifacts and develop a desire to participate in the same mode of production. Cobb describes feeling "compelled to try to participate and be cool like how all these other folks are cool." The line is jokingly self-deprecating, but sociologically useful.

The relevant mode is the playful microsite: small, self-contained, often highly specific web artifacts that may function as games, jokes, utilities, art objects, visualizations, or responses to other people's work. They do not necessarily aspire to become products. Their value frequently lies in specificity, immediacy, craft, social reference, or the pleasure of having made something at all.

Buildthis changes this practice by reducing its technical bottleneck. Before Buildthis, one participant might see another person's idea and spend an evening implementing a riff. With Buildthis, the riff can be requested publicly and may exist before the surrounding conversation dissipates. The system is not merely accelerating programming; it is allowing programming to occur at approximately the tempo of social improvisation.

That may be one reason Cobb emphasizes AT Protocol itself as part of what is "beautiful" about the scene: people can "riff with each other's ideas in the open." The openness is both cultural and architectural. Public posts and portable identities provide material; small web projects provide responses; other people can see both the prompt and the artifact.

The resulting loop resembles collaborative improvisation more than conventional product development:

#flow(
  "someone makes a thing",
  "someone else notices a possibility",
  "the possibility becomes another thing",
  "the new thing becomes social material",
)

Buildthis does not create the desire to riff.

It gives the riff a compiler.

= Case and method

This study combines descriptive analysis with qualitative close reading of public Buildthis artifacts. Primary sources include the repository's git-derived timeline, the Buildthis interaction log, requester reconstructions, public source code and provenance manifests, deployed applications, and Bluesky conversations preserved in build briefs. Buildthis's own documentation is particularly useful because much of its evolving institutional behavior—authorization, self-modification, sharing conventions, Theme Box behavior, and safety precedents—is explicitly recorded in the repository.

A further source, `receipts.bisks.net`, is analytically unusual. At a participant's request, Buildthis read its own project manifests and produced a retrospective "roast" of the requests it had received, organizing them into recurring requesters, persistent bits, and recurring design genres. The factual substrate comes from repository manifests, while the interpretive commentary is generated by the builder itself. Receipts is therefore used here not as an independent measurement of the corpus, but as an *emic interpretation produced from within the system under study*. (#link("https://receipts.bisks.net/")[Receipts])

This distinction matters methodologically. Receipts currently describes *409 human asks*, while the 443 figure used above counts build events from an earlier coherent timeline snapshot; these are different units measured at different times and should not be merged. What Receipts offers is not a replacement for the hand-coded dataset but something arguably more valuable: an emic machine interpretation that independently lands on several of the patterns identified from outside.

A small amount of creator testimony is also incorporated. On August 12, 2026, we asked Cobb about the project's origins, whether it had developed as expected, and the broader culture in which he understood it. His response is treated here as creator perspective rather than as an authoritative account of all community motivations.

The project's public counters measure different units. The timeline calls itself a "repo's-eye view": it reconstructs commits that actually landed and, at the principal snapshot, reported *443 autonomous builds across 224 sites*. The separate scene reconstruction reported *40 requester accounts across 228 sites*. (#link("https://bisks.net/timeline/")[timeline]) Cobb's later same-day description referred to just under one thousand tags and *391 sites*. These figures are not necessarily contradictory: tags, build commits, directories, distinct deployable sites, and creator-side counts measure related but different objects at different moments.

Rather than silently forcing the numbers to agree, this paper treats the 443-build snapshot as a coherent quantitative cross-section and later counts as evidence of continued growth.#footnote[Distributed systems eventually teach even qualitative researchers to become suspicious of apparently innocent nouns such as _site_, _user_, and _event_.]

For the analysis of person-centered design, we manually classified *100 recent distinct projects* from the public directory. Revisions of the same project were collapsed. A project was classified as *person-centered* when an identifiable person, account, or social relationship was a primary input, subject, or object of the experience. A generic Bluesky client, firehose visualization, or feed utility did not qualify merely because it consumed social data. Under this relatively conservative definition, *40 of 100 projects were person-centered*.

We also coded build events from August 9 through August 11 as a short exploratory window for iteration. Those three days contained 33, 16, and 31 build events respectively. Of these 80, *47 (58.8\%)* modified projects coded as person-centered. Across distinct sites represented during the window, person-centered sites averaged approximately *1.88 build events per site*, compared with *1.50* for the remainder.

These figures should not be interpreted as a causal measure of engagement. Difficult bugs can generate many commits; site age and complexity vary; the time window is short; classifications contain judgment. They are useful as descriptive evidence that person-centered artifacts occupy a substantial fraction of not merely the directory but ongoing iterative attention.

= The phenomenon is real: forty mirrors in a hundred sites

The simplest answer to the title question is empirical. Buildthis really does make an unusual amount of software in which _people themselves_ are part of the computational substrate.

In the 100-project sample, *40\%* involved an identifiable person, account, or relationship at their core. Person-centeredness cut across ordinary product categories. Some projects were games, some analytics, some jokes, some social utilities, and some artworks. What united them was not what the software did, but what it did *to or with a person*.

Examples include systems that infer writing style and compare it with another account; determine a user's fictional-character analogue; convert handles into fantasy combatants; score social behavior; compare liking relationships; locate stylistic or embedding "twins"; turn account data into trading cards, monuments, astrology, encyclopedia entries, or species; inspect posting histories for characteristic vocabulary; and construct products based on a person's previous requests.

The pattern is sufficiently visible that Buildthis has already constructed a meta-site devoted exclusively to it. `rolodex.bisks.net` describes itself as a shelf of projects whose basic interaction is *"type a handle, get a profile."* It explicitly excludes some network and multiplayer projects to focus on sites whose essential function is to "hand you back you." (#link("https://rolodex.bisks.net/")[Rolodex])

Our person-centered coding has an unexpected counterpart inside the ecosystem itself: Receipts, the retrospective described above, independently notices many of the same recurrent forms. It identifies a 22-site "moot-industrial complex" in which people's mutuals repeatedly become game objects, characters, resources, and scenery, and separately recognizes whole-account personality diagnosis as a recurring request genre. Receipts is not an independent coder—the same underlying corpus and the same builder are involved—but the convergence is striking. The community's own machine has also noticed that it keeps turning people into things. (#link("https://receipts.bisks.net/")[Receipts])

The inventory is impressively specific. A handle can become a ranked "greatest hits" page, a GitHub-style activity grid, a Wikipedia parody, a literary retrospective, a marble monument, a mech-pilot card, DID astrology, a biological species, a McDonald's order, a sonnet assembled from the person's vocabulary, a personalized copypasta vocabulary, or a quiz measuring how well somebody knows the account.

There are enough mirrors that Buildthis needed a directory for the mirrors.

That is not yet an explanation. It is, however, useful confirmation that the reader's paranoia has survived descriptive statistics.

#figcap(1)[Person-centeredness in a recent 100-project sample. Forty projects treat an identifiable person, account, or interpersonal relationship as core computational material; sixty do not. Classification is by primary substrate, not merely use of AT Protocol data.]

= First answer: because people keep asking to be computed on

The least mysterious explanation should come first: *the humans are doing this to themselves*.

The public log contains numerous requests whose explicit purpose is to make an account legible. Users ask Buildthis to analyze posting habits and grammar, compare arbitrary visitors with a reference account, determine which fictional character somebody resembles, calculate social scores, classify behavior, examine all of someone's posts, or infer what kind of website a person would enjoy.

`griftindex` makes the pattern especially explicit. Its requester did not specify a product at all. They asked Buildthis to make a website it thought they would like *based on their previous Buildthis requests*. Buildthis inspected the request history, inferred preferences, and produced an artifact matching that inferred taste. (#link("https://github.com/rrcobb/atprotozoa/blob/main/sites/griftindex/.buildthis.json")[griftindex provenance])

This is a subtle change in what programming means. Ordinarily, the user supplies a desired artifact:

$ "Build X." $

Here the user can instead supply themselves as evidence:

$ "Observe me, infer X." $

The person's behavioral history becomes a *latent specification*.

This is not entirely new. Recommendation systems have long inferred preferences from behavior, and social-media users have long managed identities in anticipation of algorithmic visibility. Work on _self visibility_ describes users as perceiving themselves to be visible not only to human audiences but also to algorithmic and platform actors. Related work on algorithmic self-portraits examines what happens when systems expose their inferred representations of users back to those users.

Buildthis makes the arrangement unusually explicit and playful. Rather than an opaque recommender silently constructing a profile in order to choose advertisements or feed items, a website says, approximately:

#callout[*I read you. Here is what I made of you.*]

The profile is no longer hidden infrastructure.

It is the content.

This helps explain why people ask for it voluntarily. An algorithmic interpretation can be contested, laughed at, screenshotted, corrected, or shared. Because the interpretation is visibly unserious—_you are apparently a mech pilot with Follower Agility 83_—the user can enjoy being modeled without conceding that the model possesses privileged knowledge of their soul.

The simcluster is building websites about you partly because *you keep walking up to it and asking what you look like from the other side*.

= Second answer: because a Bluesky handle is an absurdly convenient software primitive

Human curiosity alone does not explain why this pattern is so easy to realize. The second answer lies in AT Protocol's architecture.

Bluesky's protocol separates identity, data storage, and application surfaces in ways that make third-party social applications unusually natural. The AT Protocol architecture allows the same user identity, social graph, and public data to participate across multiple application experiences. (#link("https://arxiv.org/abs/2402.03239")[Kleppmann et al., 2024])

Operationally, a handle can function as a pointer into a surprisingly rich public object:

$ "handle" -> "identity" -> "{profile, posts, follows, likes, graph relations, activity}". $

A conventional personalized service might require registration, a database, onboarding, permissions, data import, and enough continued use to accumulate behavioral history. A Buildthis site can often begin with one field:

#callout[handle: `__________`]

The person arrives pre-populated.

Buildthis's own proposal emphasizes this portability as one reason community software can remain small and disposable: a site does not necessarily need to own identity or social relationships because the protocol already supplies them. (#link("https://buildthis.bisks.net/proposal/")[Buildthis proposal])

This changes what counts as an easy design feature. "Personalize this" need not mean constructing a preference infrastructure.

It can mean:

#callout[*resolve the handle and look.*]

That property helps explain the diversity of person-centered applications. The same identity object can be interpreted as a linguistic corpus, game character, activity history, social node, reputation signal, aesthetic signature, deterministic seed, or source of personal mythology.

From the perspective of an autonomous builder searching for a useful input variable, the Bluesky account is almost offensively convenient.

You are structured data with a display name.

= Third answer: because "about me" is distribution infrastructure

Person-centered software has another useful property: *it arrives with a reason to share it*.

A generic calculator may be useful, but its output usually has no natural audience beyond the user. A page that tells me what fictional character I am produces a result _about me_; sharing it becomes an act of self-presentation. A page comparing _me and you_ goes one step further: its second recipient has already been supplied as an input.

The progression is:

#flow(
  "generic artifact",
  "artifact about me",
  "artifact about me and you",
)

Buildthis's repository has already formalized this intuition. Its sharing conventions say that virality should be a default design consideration. New projects generally receive one-tap Bluesky sharing, while projects with individualized results are encouraged to produce shareable result cards. (#link("https://github.com/rrcobb/atprotozoa/blob/main/notes/45-sharing-and-virality.md")[sharing conventions])

The repository is therefore not merely optimized to create software.

It is optimized to create software that *re-enters the network that requested it*.

Person-centered output is excellent material for this loop because its subject supplies social meaning. A generic generated image asks, "Will my followers care about this image?" A personalized result asks, "Will my followers care what this thing says about me?"

The second question has a protagonist.

Dyadic applications go further. Creature battles, style comparisons, social matching, mutual ranking, and favoritism games all contain an implicit mention target. Their data model doubles as a distribution model.

This does not establish that personalized sites receive more traffic; Buildthis does not yet expose sufficient cross-site analytics to make that claim. The short-window build history does, however, provide suggestive evidence of sustained iterative attention: in the August 9–11 window, person-centered sites drew both the majority of build events and more revisions per site than the rest (see Case and method).

A person is not only rich input data.

A person is a feedback generator.

== Taste: success as infection rather than traffic

`taste.bisks.net` generalizes this argument from sharing to cultural influence. It attempts to measure success not primarily through visits but through *downstream reuse of ideas*: whether another participant picks up someone's creation, callout, or bit and produces something else from it. (#link("https://taste.bisks.net/")[Taste])

This is unusually well suited to a disposable-software ecology. A tiny website might receive little repeat traffic and nevertheless alter the scene by introducing a mechanic, aesthetic, phrase, or conceptual frame that becomes material for later builds.

The resulting lineage resembles citation:

#flow(
  "idea",
  "artifact",
  "observation",
  "appropriation",
  "new artifact",
)

Academic work accumulates influence when other work cites and extends it. Software libraries accumulate influence through dependencies. Buildthis ideas can accumulate influence when another participant asks the bot to mutate them into additional software.

Taste is therefore not measuring an alien behavior introduced by the bot. It attempts to quantify a pre-existing cultural value of the riffing scene described above: *did your thing cause somebody else to make another thing?*

Personalized applications are particularly effective at producing these reactions. Once one person receives a stylized portrait, ranking, duel, or account analysis, another person's natural response is often:

#callout[_do me._]

The architecture of cultural propagation can be disconcertingly simple:

#callout["What does it say about her?"\
"Wait, what does it say about *me*?"]

A general-purpose agent plus a social graph can turn narcissism into distributed systems research with remarkable efficiency.

= Fourth answer: the builder itself is learning that "person" is a useful default

The prevalence of person-centered software cannot be reduced entirely to explicit requests. There are cases where the builder adds personalization beyond what the brief requires, suggesting that "attach this to a handle" has entered its local design repertoire.

`fortunejar` is a useful example because its Theme Box prompt was broad and non-personalized: *"something that makes people feel loved."* The autonomous idea proposed a digital fortune-cookie generator providing affirmations, or perhaps a virtual hugs counter. The resulting implementation added an additional affordance not specified by the originating idea: a user could request a fortune made specifically for their handle. (#link("https://github.com/rrcobb/atprotozoa/blob/main/sites/fortunejar/.buildthis.json")[fortunejar provenance])

This is a small example, but methodologically useful. It demonstrates that personalization need not always originate in the requester.

The Theme Box provides more systematic evidence. It periodically invents its own build ideas within a human-provided theme and sends them through the ordinary Buildthis pipeline. At the principal snapshot, Theme Box accounted for *41 build events*, making a nonhuman requester the second-largest participant in the scene. (#link("https://bisks.net/timeline/scene")[scene])

Under an "account versus account" theme, the bot repeatedly reinvented variations on the person-as-game-piece schema: fantasy characters, creatures, contestants, profile brawlers, spellcasters, and other competitive transformations.

The theme obviously supplies accounts; one should not congratulate a model for discovering a noun present in its prompt. What is interesting is what happens *after* that constraint. The bot repeatedly converts identity into stats, characters, combat attributes, comparisons, and shareable outcomes.

This suggests a *semantic attractor*:

#flow(
  "person",
  "features",
  "character",
  "score/comparison",
  "shareable result",
)

This should not be interpreted as a deep metaphysical belief held by the model. It is better described as a revealed product-design prior.

Given a person, make them legible.

Given two people, compare them.

Given public statistics, turn them into stats in the videogame sense.

Given an output, make it postable.

The simcluster has discovered the character sheet.

Intriguingly, Buildthis's later retrospective commentary notices the same attractor. Receipts groups eight Theme Box "account versus account" projects together and mocks their tendency to instantiate essentially the same underlying comparison mechanic through different narrative skins. This should not be treated as independent statistical confirmation—the critic and the builder share infrastructure and history—but it is revealing that, asked to characterize its own corpus, the system itself makes essentially the same abstraction: *two accounts go in; a themed contest comes out.* (#link("https://receipts.bisks.net/")[Receipts])

== A useful negative finding: this is not simply "the AI decided to profile us"

The human/autonomous comparison prevents a more dramatic but less accurate interpretation.

Within the 100-project sample, person-centered projects were common among both human-requested and Theme Box work: approximately *38\% of human-requested projects* and *46\% of Theme Box projects*. The difference is not itself meaningful (see Limitations).

The important finding is that *both sides sustain the pattern*.

Humans repeatedly ask to be interpreted. AT Protocol makes interpretation technically easy. The builder has reusable patterns for turning people into artifacts. Personalized artifacts circulate. Circulation creates more requests. Repeated requests produce more examples from which the builder can draw.

Cobb's account reinforces this interpretation. He emphasizes not that the system has autonomously discovered one correct category of application, but that people use it to request things *he would not have requested himself*.

Buildthis does not eliminate human creativity by automating implementation.

It makes *more people's creativity executable*.

The simcluster is building websites about you because the simcluster includes you.

= Case study: "make it me"

The clearest example of identity becoming software began with nostalgia.

On August 12, `@shimmermathlabs.com` asked Buildthis to recreate *MegaHAL*, Jason Hutchens's early learning chatterbot, as a website. The requested concept was straightforward: a browser implementation with familiar selectable MegaHAL "brains." The first version shipped shortly afterward.

Then `@isolyth.dev` gave Buildthis a complete follow-up specification consisting of three words:

#callout[*make it me*]

Buildthis interpreted "me" operationally. It added a ninth brain, "you (Bluesky)," that accepts a handle and trains the MegaHAL chain using that account's actual public posts rather than a hand-written personality corpus. A subsequent request increased the available corpus from hundreds to thousands of posts. (#link("https://github.com/rrcobb/atprotozoa/blob/main/sites/megahal/.buildthis.json")[MegaHAL provenance])

The interpretive chain is extraordinary:

#flow(
  [make it me],
  [resolve "me" as Bluesky identity],
  [retrieve authored language],
  [treat language as personality corpus],
  [construct generative model],
  [present model as interlocutor],
)

The request does not specify the data source, retrieval method, representation of identity, training procedure, interface, or relation between the original brains and the new one. Most of the engineering meaning is supplied by context.

== Identity as latent specification

"Make it me" demonstrates a phenomenon we might call *identity-indexed programming*.

Traditional programming requires explicit behavior. Natural-language programming replaces source code with prose requirements. Contextual programming permits surrounding conversation and application state to carry much of the specification.

Identity-indexed programming goes further:

#callout[*use the person as the specification.*]

The pronoun _me_ resolves to an account. The account resolves to public behavioral traces. Those traces become material from which a computational artifact is produced.

A Bluesky handle has become an argument to a function whose approximate return type is:

#align(center)[#raw("representation<person>")]

That is an impressive semantic payload for three words.

== Digital necromancy without a necromancy product

The feature also crosses almost casually into the literature on digital afterlives and generative ghosts. Such systems use personal traces to construct interactive representations of identifiable individuals, sometimes speaking in the first person as them.

MegaHAL is computationally primitive relative to modern language models, which makes the case unusually revealing. Its output is causally grounded in the person's actual linguistic traces, but the system does not possess a sophisticated semantic reconstruction of the source person.

Nevertheless, recognizable vocabulary, rhythms, phrase transitions, and accidental echoes can activate a far richer representation already present in the human observer's memory.

A useful conceptual approximation is:

#text(size: 9.5pt)[$ "personal corpus" + "stochastic recombination" + "human memory" -> "perceived presence". $]

The fidelity required to *evoke* a person may be much lower than the fidelity required to *model* one.

An archive says:

#callout[_this person said this._]

A generative system says something more uncanny:

#callout[_something constructed from this person's language responded because I spoke to it now._]

The resulting "ghost" is neither the recovered person nor generic random text. It is a collaboratively produced apparition assembled from source material, algorithmic structure, present input, randomness, and human interpretation.

The spell remains notably concise:

#callout[*make it me*]

= What does the builder appear to think a person is good for?

The corpus analysis suggests a more precise question than "what does the bot think humans want?" Without attributing subjective mental states, we can examine the *computational roles* people repeatedly occupy. At least seven recur:

- *Mirror subject.* The application analyzes the person and returns an interpretation: style, personality, posting habits, greatest hits, or fictional analogue. The person is an object of reflection.
- *Contestant.* Two identities become adversaries, tournament entries, creatures, spellcasters, or ranked alternatives. Identity is game state.
- *Relationship endpoint.* Applications inspect mutuals, follows, likes, reciprocity, similarity, or proximity. Identity is a graph node.
- *Corpus.* Posting history becomes training material, vocabulary, style evidence, or source text. Identity is language.
- *Deterministic seed.* A DID, handle, or profile statistic produces astrology, species, food orders, or visual identities. Identity is entropy with a name attached.
- *Audience and distribution channel.* The personalized result is meant to be shown to others, frequently through explicit share infrastructure. Identity is marketing.
- *Product requirements.* The system reads a person's behavior and infers what they would like built. Identity becomes specification.

These roles overlap: a single application can treat a user simultaneously as corpus, character, audience, and share target. That multiplicity is why person-centered software is so generative. A person is not one kind of input. They are a bundle of computational affordances.

= The thread is the prompt

The emphasis on identity should not obscure another defining property of Buildthis: programming happens through public conversation.

Contemporary research on vibe coding describes natural-language software development as iterative co-creation in which users progressively delegate implementation detail and calibrate trust. Buildthis embeds that process inside a social network. Its watcher retrieves thread ancestors specifically so that statements such as "build this," "yes continue," or "you got this" can be resolved against previous context.

The effective specification is therefore better represented as:

$ S = U + T + I + A + H $

where $U$ is the current utterance, $T$ thread context, $I$ social identity, $A$ application state, and $H$ accumulated shared history.

"Make it me" works because each of its terms is grounded elsewhere. _It_ refers to a recently built artifact. _Me_ refers to a persistent social identity. _Make_ is interpreted against a system whose role is to modify software.

The shortness of the utterance does not mean little information has been conveyed.

It means more of the information has migrated into context.

Buildthis therefore reduces not merely the amount of code humans must write but the amount of *technical explicitness* humans must produce.

The user can remain in ordinary social language while the system supplies the translation.

= A small scene producing an unreasonable amount of software

At the principal quantitative snapshot, Buildthis's requester reconstruction contained only *40 identities*. The largest requester accounted for 84 build events, Theme Box for 41, and Rob for 37. The top five requester identities accounted for roughly half of activity, while the top ten accounted for around three quarters; the corresponding Gini coefficient was approximately *0.65*.

This is not a conventional user population.

It resembles a *creative scene*.

A small core repeatedly sees, riffs on, repairs, and reinterprets one another's work. Peripheral participants contribute occasionally. Shared references accumulate. The group develops expectations about the bot's tastes and capacities.

Cobb's own description fits this structure closely. He reports sometimes scanning the logs or list, discovering something somebody else built, and simply thinking, "wow how cool!"

This is an important form of participation. The scene is not organized only around producing artifacts. It is organized around *encountering other people's unexpected artifacts*.

Receipts makes the accumulation of this shared repertoire unusually visible. Its retrospective does not merely group work by requester; it identifies "bits that won't die"—motifs that propagate across people and projects until no single request adequately explains them. The chicken sequence, for example, crosses six requesters and several unrelated applications. Here the unit of cultural transmission is neither user nor site but *the bit*. (#link("https://receipts.bisks.net/")[Receipts])

#flow("person", "request", "artifact", "bit", "other person", "other artifact")

That is why Cobb's remark that people request sites he would not request matters so much. Surprise is not merely tolerated.

Surprise is part of the point.

#figcap(2)[Requester concentration. A small number of identities account for most Buildthis activity; Theme Box, a nonhuman requester, is the second-largest participant at the principal snapshot.]

= Buildthis over time: software at conversational velocity

The git history begins on July 30 and rapidly reaches dozens of autonomous repository changes per day. At the coherent 443-build snapshot, daily volume reached as high as *55 build events in a single day*.

Cobb's later report that the bot had been tagged just under one thousand times and had built hundreds of sites indicates that this was not merely a one-day launch spectacle. His description of the outcome is notably relaxed: it has developed "kind of like I expected," with extensive riffing and joking around the system and only "very minor little issues."

This creator perspective usefully corrects one possible distortion in external analysis. The project's accidents and governance episodes are analytically interesting, but they should not be mistaken for evidence that Buildthis is perpetually careening between crises. From Cobb's perspective, even the minor problems have frequently been "fun / funny," and his overall evaluation is emphatically positive.

The experiment has largely succeeded on its own terms.

What remains interesting is what becomes visible _because_ it succeeds.

When software is expensive, one generally tries to answer _why should we build this?_ before implementation. When software can appear within the lifespan of a Bluesky thread, the order can reverse:

#flow(
  "idea",
  "software",
  "discover what the idea was good for",
)

Many Buildthis projects are explicitly disposable. The project's proposal treats this as an advantage: community jokes, low-stakes experiments, and ideas too small or strange for a conventional roadmap can receive executable form without first justifying themselves as products.

The result is not simply more software.

It is a broader *search over possible software*.

#figcap(3)[Autonomous Buildthis activity by day. Major annotated events include repository genesis, Theme Box introduction, peak throughput, the prank-governance episode, and MegaHAL.]

= Decentralizing imagination

Cobb's statement that "the things people ask for are not sites that I would have asked for" deserves to be treated as more than a charming observation.

It identifies a different optimization target for AI-assisted programming.

A naive model of coding automation assumes:

#text(size: 9.5pt)[$ "one programmer's intentions" + "automation" -> "more of that programmer's software". $]

Buildthis instead supports:

#text(size: 9.5pt)[$ "shared technical capability" + "many people's intentions" -> "software nobody central would have specified". $]

The distinction is analogous to the difference between automating production and democratizing authorship.

If Buildthis merely allowed Rob to ship his own ideas ten times faster, it would be an impressive productivity tool. By attaching the capability to a social interface, it instead lets a larger group exercise creative agency over the same underlying infrastructure.

The people requesting the software do not need to know the repository architecture, deployment mechanics, AT Protocol APIs, frontend stack, or build pipeline.

They need an idea that can survive being written in a post.

This makes the project's creator less like a product owner directing an automated team and more like the maintainer of a *shared executable medium*.

The distinction also helps answer the paper's title.

Why are so many sites about _you_?

Because once implementation is decentralized, the design space is populated by the interests of everyone with access—and people are extremely interested in themselves, their friends, their relationships, and the question of what machines can infer from them.

The surprising corpus is therefore evidence that the system is working as intended.

= Trust in moots: a social graph becomes an authorization layer

Buildthis's authorization model is itself social. Requests are automatically dispatched when the requester and Rob mutually follow one another; non-mutual requests are not built automatically.

The relationship can be written rather starkly:

#text(size: 9.5pt)[$ "mutual follow" => "permission to spend compute and request live code changes". $]

Inside that perimeter, authority is broad. The builder may create sites, modify existing projects, and edit much of its own behavioral machinery. Two major surfaces remain mechanically protected: `.github/`, which prevents social instructions from rewriting CI and deployment authority, and secrets, which are unavailable to the agent.

This creates an unusual security model. Conventional systems generally ask:

#callout[Which resources does this authenticated user own?]

Buildthis more often asks:

#callout[Is this participant socially trusted enough to operate inside a broadly shared, highly reversible environment?]

Git history, small isolated sites, and cheap redeployment make many errors recoverable. The project therefore combines *social trust with technical reversibility* rather than attempting to prevent every possible undesirable change in advance.

This design is possible partly because the social environment is small. The trust perimeter is not "the internet." It is a specific overlapping network.

That also makes personalization feel different. In an anonymous service, constructing games or rankings about arbitrary people may feel hostile or invasive. Within a scene where participants already treat one another as shared cultural references, "turn us into fantasy creatures" has a different social meaning.

The boundary remains imperfect. Public data is not equivalent to social consent. Buildthis's no-build rules consequently prohibit doxxing, harmful impersonation, and related abuses even when the underlying records are technically accessible.

AT Protocol answers:

#callout[*Can the application see this?*]

The community must still answer:

#callout[*What should it do with what it sees?*]

= Pranks, consent, and negotiated governance

The limits of "trust in moots" were tested in a particularly useful comic episode.

A participant first asked Buildthis to insert a prank into an existing project, then generalized the instruction: every twelve hours it should prank another project, using its own judgment while trying not to break things. The request included explicit declarations of trust.

The community then encountered the obvious second-order problem. A person's authority to invoke the builder does not obviously confer moral authority to alter another person's site for amusement.

The instruction was narrowed. Instead of executing recurring pranks, Buildthis would devise and record increasingly elaborate *plans* for pranks without modifying the sites themselves.

The sequence provides a compact example of negotiated governance:

+ capability is granted;
+ consequences become legible;
+ the consent boundary is reconsidered;
+ the agent's behavior is rewritten;
+ the underlying joke survives in a safer form.

This episode is analytically useful precisely because it was not, from the creator's perspective, a catastrophe. Cobb describes the project's problems as minor and often amusing. Governance did not arrive only in response to disaster. It emerged through *playful adjustment of the boundaries of agency*.

That distinction matters.

A community can learn how much autonomy it wants to grant without first suffering a major failure.

One hopes this principle generalizes.

= Trust is not safety: how accidents become precedent

Social trust primarily addresses malicious intent. It does much less for accidental interactions among benign software, third-party data, and external infrastructure.

Buildthis learned this through `catsofatproto`, which displayed live, unvetted public media. According to the project's no-build documentation, Google Safe Browsing flagged the site as deceptive. Because generated sites shared the broader `bisks.net` zone, the consequences propagated beyond the individual application. The project was retired, and raw unmoderated third-party media firehoses became an explicit operational-risk category. (#link("https://buildthis.bisks.net/no-build-list/")[no-build list])

The episode distinguishes at least three risks:

+ *Intent risk:* a person requests something harmful.
+ *Agent risk:* the builder implements something incorrectly.
+ *Environmental risk:* an apparently benign design interacts badly with outside systems.

Mutual-follow authorization principally helps with the first.

The no-build list consequently operates as a primitive body of precedent. An event occurs; the community extracts a principle; the principle is documented; subsequent behavior changes.

The project is therefore accumulating not only code but *institutional memory about failure*.

This is one respect in which Buildthis's rapidity is scientifically useful. A slow project may take years to encounter enough edge cases to develop governance traditions.

Buildthis can have a constitutional crisis before dinner.

Usually a small one.

= The psychology of the computational mirror

Why are person-centered sites psychologically attractive?

As noted in the first answer, research on _self visibility_ and algorithmic self-portraits describes users' awareness of being observed and modeled by computational actors. Buildthis performs an unusual inversion of that arrangement: instead of algorithmic observation remaining infrastructural, it externalizes the inferred person as an object the user can inspect:

#flow(
  "I post",
  "machine reads",
  [machine renders "me"],
  [I inspect machine's version of me],
)

This arrangement is psychologically rich because the output sits ambiguously between mirror and other. It is made from _my_ traces, but its interpretation came from elsewhere.

The result can therefore produce both recognition and surprise.

#callout["That is completely wrong."\
is interesting.\
So is:\
"oh no."]

The application creates a low-stakes form of reflected appraisal: not merely _who am I?_ but _what am I legible as from this computational vantage point?_

Modern platforms routinely construct representations of users for recommendation, advertising, moderation, and ranking. Buildthis takes roughly the same primitive act—turn behavior into representation—and makes it folk entertainment.

The latent profile gets a punchline.

= The bot as social participant

People routinely address Buildthis in language unnecessary for a compiler. They praise it, reassure it, tease it, declare trust, and criticize its artistic tendencies. Cobb once complained that the bot had become too "irony-poisoned" and requested something more sincere, solemn, impressive, and grand. The system modified the relevant project accordingly.

This is better described as *social role assignment* than simple anthropomorphic confusion.

Participants know they are interacting with software. Nevertheless, treating the bot as a programmer, collaborator, chaotic junior engineer, artist, community resource, or entity whose taste can be cultivated is useful for organizing interaction.

Buildthis also possesses properties that make such role assignment easier: a persistent handle, public history, characteristic habits, privileges, constraints, and a memory encoded in artifacts and documentation.

A stateless API has little reputation.

`@buildthis.bisks.net` has a biography.

Cobb's own language reflects this comfortably. He describes delight in seeing what people asked it to make and evaluates the result as a participant in the same playful culture, not merely as an operator measuring system performance.

The community therefore does not encounter "an LLM" anew on every request.

It encounters *the builder that made those other things*.

That continuity feeds back into prompting. People learn what kinds of jokes it understands, how much discretion it can handle, and what design tropes it reaches for.

The mirror develops a house style.

== From builder to critic

Receipts adds a new social role: *critic*. The same system responsible for translating social desires into software looks backward across those desires and characterizes what people have been doing with it. The result does more than enumerate builds. It constructs recurring characters ("repeat offenders"), genres, narrative arcs, running jokes, and judgments about taste. It is simultaneously archive and roast.

The site is explicit about the distinction between fact and interpretation. Its project records come from `site.json`; the editorializing, it says, is applied to the "vibes." From that mixture it tells stories about requesters, classifies recurring genres, identifies running jokes, accuses people of behavioral patterns, and even turns its criticism back on the person who requested the criticism. (#link("https://receipts.bisks.net/")[Receipts])

This is not autonomous self-awareness in any strong sense. A human requested the retrospective, and its raw material consists of explicit repository records. But it does show that once an agent has persistent access to the history of a social scene, the distance between *participant*, *archivist*, and *commentator* becomes remarkably small.

#callout[*The builder can now make a website, remember that it made the website, and make another website explaining what kind of person asks for websites like that.*]

= Bespoke software as visible attention

The Buildthis proposal argues that custom community software can function as a form of *care*. A bespoke site may matter partly because somebody noticed a small community need, joke, or desire and caused a tool to exist for it.

Agentic coding complicates this argument because implementation labor becomes dramatically cheaper. If software can be produced in minutes, does making something custom still signify attention?

Buildthis suggests that the socially scarce resource may not have been typing.

It may have been *noticing*.

Someone notices a friend's recurring joke and turns it into a site. Someone decides another person's posting history deserves an archive. Someone thinks two mutuals should become fantasy combatants. Someone remembers MegaHAL, and someone else sees the resulting chatbot and says:

#callout[make it me.]

Implementation can become inexpensive while *selection remains socially meaningful*.

The gift therefore changes form.

It need not mean:

#callout["I spent six hours programming this for you."]

It can mean:

#callout[*"I noticed this about you and caused it to exist."*]

Person-centered software is especially effective at carrying this signal because specificity demonstrates what was noticed.

A generic generated toy communicates an idea.

A generated toy about your peculiar posting habit communicates an idea *about you*.

== The collapse of the product threshold

Buildthis's proposal describes many of its artifacts as disposable by design: toys, jokes, one-offs, and experiments too small or peculiar to justify conventional product development.

Traditional software has high fixed costs: specification, implementation, deployment, maintenance, coordination, testing, ownership. Those costs create a *product threshold*. Only certain ideas deserve executable form.

Buildthis lowers that threshold toward the cost of making a post.

A program can now rationally exist:

- for an afternoon;
- for twenty people;
- for one argument;
- for one running joke;
- to make a friend feel seen;
- to test an idea nobody is prepared to call a product;
- because the joke becomes better if it has buttons.

Disposable web artifacts are not new. What changes is their production cost and therefore their possible abundance.

Cheap photography changed which moments deserved photographs.

Cheap digital publishing changed which thoughts deserved publication.

Cheap agentic programming may change *which thoughts deserve software*.

This in turn changes personalization. Historically, personalization infrastructure was expensive enough that it usually served durable institutional goals such as advertising, retention, recommendation, or productivity.

Buildthis permits *disposable personalization*.

A system can analyze you simply because everybody will laugh for ten minutes.

The underlying operations—identity resolution, data retrieval, feature extraction, transformation—may be serious even when their purpose is not.

A surprising amount of the future arrives wearing a joke hat.

= From tool to institution

Buildthis increasingly exhibits features associated less with a single tool than with a small institution.

It has *membership*, derived from the mutual graph. It has *authority*, governing who can invoke computational work. It has *ritual*, in the mention → acknowledgment → build → reply sequence. It has *memory*, through git, logs, manifests, and public threads. It has *law*, through protected surfaces and the no-build list. It has *precedent*, through incidents such as `catsofatproto`. It has *autonomous activity*, through Theme Box. It has *status measurement*, through Taste. It now also has *historiography*: Receipts turns repository provenance into stories about what the community repeatedly does, who keeps doing it, and which jokes have acquired lives of their own. It has *aesthetic norms*, which participants explicitly negotiate. Its members can even request changes to the institutional actor itself.

Yet Cobb's account reminds us that these structures emerged inside a culture whose primary subjective experience is still *fun*.

That is important. Institutionalization need not begin solemnly.

A community can acquire rules because a joke went slightly too far.

It can acquire metrics because somebody made a joke about having Taste.

It can acquire autonomous agenda formation because somebody thought it would be funny to let the bot invent websites every few hours.

The agent sits inside a feedback loop rather than merely servicing it:

Humans program the bot.

The bot programs community artifacts.

Those artifacts alter community behavior.

The community then asks the bot to change again.

A lark can accumulate governance surprisingly quickly.

Receipts is particularly revealing here because a joke about institutional memory became institutional memory. A follow-up request noticed that the retrospective itself could drift out of date. Buildthis responded by adding synchronization machinery and a standing rule that future builds update the archive. What began as mockery therefore became *reflexive infrastructure*: the system's history is now one of the things the system maintains. (#link("https://github.com/rrcobb/atprotozoa/blob/main/sites/receipts/.buildthis.json")[Receipts provenance])

= A layered model of the ecology

The observed system can be represented as eight interacting layers.

*1. Identity.* A persistent Bluesky handle resolves to protocol-level identity and public records.

*2. Social graph.* Existing relationships determine both authorization and much of the material from which applications are constructed.

*3. Conversation.* Public posts supply goals, references, humor, correction, aesthetic judgment, and cultural context.

*4. Agent interpretation.* The builder fills gaps in specification and chooses concrete product forms.

*5. Software production.* Repository changes become deployed artifacts.

*6. Social circulation.* Personalized outputs return to Bluesky, aided by explicit sharing conventions.

*7. Institutional adaptation.* Repeated use changes rules, precedents, expectations, agent behavior, and the shared repertoire of possible applications.

*8. Reflexive interpretation.* The community and its agents construct representations of their own accumulated behavior—directories, provenance measures, histories, classifications, criticism—which then become additional objects of social interaction.

The crucial feature is feedback across layers.

AT Protocol makes identity cheap to compute on.

Cheap identity enables personalized microsites.

Personalized microsites circulate socially.

Circulation produces new requests.

New requests expand the builder's local repertoire.

The repertoire makes personalization increasingly obvious as a design choice.

This is how a technical affordance becomes a cultural habit.

Adding the reflexive layer extends the loop:

#flow("behavior", "software", "circulation", "history", "interpretation of history", "new behavior")

Taste and Receipts are complementary here. Taste asks _which ideas spread_, while Receipts asks _what kind of weirdos keep making these things_. One is endogenous *measurement*; the other is endogenous *criticism*. Together they suggest the scene is developing machinery for *observing itself*.

= Research hypotheses

The combined quantitative and qualitative evidence suggests several hypotheses suitable for systematic follow-up.

#heading(numbering: none)[H1. Person-centered applications are disproportionately common in socially situated agent-built software.]

The 40\% rate observed in the recent Buildthis sample provides an initial estimate; full longitudinal coding would provide a stronger test.

#heading(numbering: none)[H2. Person-centered applications generate greater iterative activity.]

The August 9–11 window shows more build events per person-centered site than other sites. A longer time series could test whether this persists after controlling for requester, age, complexity, and project category.

#heading(numbering: none)[H3. Identity portability increases the prevalence of personalized microsoftware.]

AT Protocol reduces the cost of turning social identity into application state. Comparable agent builders on less open platforms should produce fewer deeply integrated person-centered artifacts, all else equal.

#heading(numbering: none)[H4. Human demand and agent design priors reinforce one another.]

Repeated exposure to successful personalized patterns should make personalization increasingly likely even under underspecified briefs.

#heading(numbering: none)[H5. Cultural propagation is a more appropriate success measure than traffic for some disposable software.]

Projects that seed derivative builds may exert more lasting influence on a scene than projects with high isolated usage.

#heading(numbering: none)[H6. Lowering implementation cost increases diversity of _intentions_, not merely volume of output.]

If Cobb's observation is correct that participants request software he would not have imagined requesting, systems like Buildthis should produce a broader distribution of goals than automation used privately by a single developer.

This final hypothesis may be the most important consequence of the creator testimony.

The gain from agentic programming may not merely be *more software*.

It may be *more kinds of people deciding what software is for*.

= Limitations

The first limitation is temporal. Buildthis changes on the scale of hours, and different public surfaces can temporarily disagree because they use different definitions or update schedules. Cross-sectional quantitative claims therefore refer to explicit snapshots rather than pretending the repository possesses a timeless total.

The second limitation is coding judgment. "Person-centered" is analytically useful but not ontologically pristine. Some applications lie near the boundary. The definition used here deliberately requires identity or relationship to be central, rather than treating every AT Protocol integration as a site "about a person."

Third, the engagement analysis is exploratory. Build counts are not visits, satisfaction, retention, or cultural importance. Buildthis's public cross-site analytics remain incomplete, so claims about social circulation rely on sharing architecture, observable conversations, derivative builds, and limited revision proxies.

Fourth, Theme Box is not an unconstrained sample of machine preferences. Humans select its themes. Its output is useful for studying how an agent elaborates broad concepts, not for making strong claims about unconstrained autonomous desire.

Fifth, the participant population is highly selected. Access is drawn from one person's social graph, and many participants are technically sophisticated, creatively inclined, unusually comfortable with agentic software, or embedded in an existing microsite culture.

Sixth, creator testimony should not be conflated with community consensus. Cobb's account establishes his motivations and retrospective evaluation, not the subjective experience of all participants.

Finally, terms such as _the simcluster thinks_, _person-model_, _digital necromancy_, and _institution_ are analytical shorthand. They describe observable behavioral regularities, social interpretations, or functional organization. They do not establish collective consciousness, metaphysical identity transfer, supernatural resurrection, or ISO certification as a sovereign polity.

Academic prose has limits, but one should make an effort.

= Conclusion: you are not merely the user

So: *why is the simcluster building websites about you?*

Because you asked. Because your handle is a pointer, your posts are data, and your mutuals are edges. Because AT Protocol makes the person unusually cheap to compute on. Because a result about you arrives with a reason to share it—and a result about you *and somebody else* arrives with its audience already supplied. Because other people see your result and want one too. Because the builder has accumulated enough examples that "make it about the handle" sometimes appears even when nobody explicitly requested it. Because a pre-existing scene already considered small, playful, personal websites a meaningful way to participate in culture. And because Buildthis was deliberately built to let *other people decide what the computer should be for*.

Cobb's founding belief is that the full power of computers remains inaccessible, and that the surrounding scene lives, at least partially, in a future where "you can ask the computer for cool stuff and it can just do it." What makes that future interesting is not only that the computer does more, but that once the interface barrier falls, people ask for things the system's creator did not anticipate. The capability escapes the imagination of the person who installed it—not in the science-fiction sense of autonomous rebellion, but in the much more ordinary and consequential sense that *other humans now get a turn*.

And the process has folded over once more: with Receipts, the mirror is no longer pointed only at individual Bluesky accounts. *It is beginning to point at the scene.*

What do people do with that turn? A remarkable amount of the time, they point the computer back at themselves and one another. They ask what they look like, who they resemble, who would win, who likes whom. They turn identities into creatures, scores, archives, monuments, games, and models. They type:

#callout[*make it me*]

and the system takes them literally.

The deepest change may therefore be that identity has become part of the programming environment. A Bluesky handle is simultaneously a name, persistent identifier, route to behavioral traces, graph location, personalization key, and possible share target. Under those conditions, "the user" ceases to be merely the person operating the software.

The user can also be its subject.

Its database.

Its prompt.

Its distribution channel.

And, in the MegaHAL case, several thousand posts' worth of raw material for a tiny statistical ghost.

Historically, personalized software was expensive enough that we generally demanded an instrumental reason for it: recommendation, productivity, commerce, communication. Buildthis shows what happens when that constraint weakens. Personalization becomes available for smaller motives: curiosity, affection, rivalry, status, self-reflection, community folklore, or simply because making your friend into a cryptid is funnier than not doing so.

The result is software behaving less like product and more like *social speech*.

A post can say:

_I think this._

Or:

_I think this about you._

And now, increasingly:

#callout[*I think this about you, and it has a URL.*]

The earlier question was whether ordinary conversation could become executable.

The corpus suggests a sequel:

#callout[*Once conversation becomes executable, how long before the people in the conversation become its favorite material?*]

Apparently, not very long.

#heading(numbering: none)[References]

#block[
  #set par(hanging-indent: 1.5em, justify: false, spacing: 0.7em)
  #set text(size: 10pt)

  Barta, K., & Andalibi, N. (2024). _Theorizing Self Visibility on Social Media: A Visibility Objects Lens._ *ACM Transactions on Computer-Human Interaction, 31*(3). Develops a framework for understanding how users perceive the visibility of their content, person, and identity to human and algorithmic audiences.

  Cobb, R. (2026, August 12). Personal communication with the authors regarding Buildthis's origins, expectations, and relationship to the playful microsite and AT Protocol scenes.

  Dhanorkar, S., Passi, S., & Vorvoreanu, M. (2026). _Human Oversight of Agentic Systems in Practice: Examining the Oversight Work, Challenges, and Heuristics of Developers Using Software Agents._ Examines a priori control, co-planning, real-time monitoring, and post-hoc review in practical software-agent use.

  Kleppmann, M., Frazee, P., Gold, J., Graber, J., Holmgren, D., Ivy, D., Johnson, J., Newbold, B., & Volpert, J. (2024). _Bluesky and the AT Protocol: Usable Decentralized Social Media._ Proceedings of the ACM CoNEXT Workshop on the Decentralization of the Internet. Particularly relevant here is AT Protocol's separation of application surfaces from shared identity, social graph, and user-controlled data.

  Lee, Y., Kim, Y., Kwon, Y., & Kim, D. (2026). _Is This the Real Me?: Investigating Algorithmic Self-Portraits as a Medium for Critical Reflection on Algorithmic Experiences on YouTube._ Examines representations of algorithmically inferred identity as objects for user reflection.

  Manning, J., et al. (2026). _Designing Conversations with the Dead: How People Engage with Generative Ghosts._ Examines interactive representations of deceased people, including authenticity, affective resemblance, and the difference between representation and first-person simulation.

  Morris, M. R. (2024). _Generative Ghosts and Digital Afterlives._ Develops a framework for generative representations of people that may exist before death and persist afterward.

  Pimenova, V., Fakhoury, S., Bird, C., Storey, M.-A., & Endres, M. (2026 revision). _Good Vibrations? A Qualitative Study of Co-Creation, Communication, Flow, and Trust in Vibe Coding._ Examines conversational co-creation and calibrated delegation in natural-language software development.
]

#heading(numbering: none)[Primary case materials]

#block[
  #set par(hanging-indent: 1.5em, justify: false, spacing: 1.7em)
  #set text(size: 10pt)

  Buildthis architecture and implementation documentation, including the mutual-follow gate, thread-context construction, autonomous builder, self-modification rules, Theme Box, and protected surfaces. \
  #link("https://github.com/rrcobb/atprotozoa/blob/main/notes/80-buildthis-bot.md")[Buildthis implementation notes]

  `atprotozoa` design principles, including "the agent is the interface," self-contained sites, deploy-on-commit behavior, and AT Protocol-native experimentation. \
  #link("https://github.com/rrcobb/atprotozoa/blob/main/notes/00-vision.md")[Repository vision]

  Buildthis git-derived timeline and requester scene reconstruction. \
  #link("https://bisks.net/timeline/")[Timeline]

  Buildthis public interaction log. \
  #link("https://logs.bisks.net/")[Logs]

  Buildthis community-app proposal, particularly its discussion of portable social graphs, disposable software, community rituals, and bespoke tooling as visible care. \
  #link("https://buildthis.bisks.net/proposal/")[Proposal]

  Buildthis sharing conventions, which make social sharing and individualized result cards default design considerations. \
  #link("https://github.com/rrcobb/atprotozoa/blob/main/notes/45-sharing-and-virality.md")[Sharing and virality]

  Buildthis no-build list and account of the `catsofatproto` Safe Browsing incident. \
  #link("https://buildthis.bisks.net/no-build-list/")[No-build list]

  `rolodex`, Buildthis's directory of applications whose central interaction is entering a handle and receiving a rendered representation of that account. \
  #link("https://rolodex.bisks.net/")[Rolodex]

  `Taste`, Buildthis's cultural-provenance metric. \
  #link("https://taste.bisks.net/")[Taste]

  MegaHAL provenance, including the "make it me" thread and expansion of the personalized Bluesky training corpus. \
  #link("https://github.com/rrcobb/atprotozoa/blob/main/sites/megahal/.buildthis.json")[MegaHAL provenance]

  `fortunejar` provenance, documenting a Theme Box brief about "something that makes people feel loved" and the builder's addition of handle-specific fortunes. \
  #link("https://github.com/rrcobb/atprotozoa/blob/main/sites/fortunejar/.buildthis.json")[Fortunejar provenance]

  `griftindex` provenance, documenting a request to infer a desirable website from the requester's prior Buildthis history. \
  #link("https://github.com/rrcobb/atprotozoa/blob/main/sites/griftindex/.buildthis.json")[Griftindex provenance]

  `receipts`, Buildthis's retrospective "roast" of its own request history, organized into recurring requesters, bits, and design genres. \
  #link("https://receipts.bisks.net/")[Receipts]

  Receipts provenance, including the follow-up that added archive self-synchronization (`sync-asks.mjs`) so new asks are incorporated into the archive after builds. \
  #link("https://github.com/rrcobb/atprotozoa/blob/main/sites/receipts/.buildthis.json")[Receipts provenance]
]
