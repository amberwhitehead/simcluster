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
  block(above: 1.2em, below: 1.2em, width: 100%)[
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
    #text(weight: 400, style: "italic", size: 0.64em)[Identity, attention, and socially situated software]
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
                    verification. It hardly seems fair.
                ]
            ],
          )
          amber.whitehead.997\@gmail.com \
          Shimmer #text(font: "Reey")[Math] Labs
        ],
      ),
    )
  ],
  date: "August 20, 2026",
  keywords: ("Bluesky", "AT Protocol", "agentic coding", "identity", "microsites"),
  abstract: [
    `@buildthis.bisks.net` is an autonomous software-building agent embedded in Bluesky: authorized users describe software in posts, the system reads the surrounding conversation, modifies a shared repository, deploys the result, and replies with a working application. At the principal snapshot used here, its git history contained *443 autonomous build events across 224 sites* from only *40 requester identities*.

    Much of this software is about people. In a manual classification of 100 recent distinct projects, *40% treated an identifiable person, account, or relationship as a core input or subject*. We argue that technical affordance, human psychology, and social propagation reinforce one another: AT Protocol makes identity cheap to resolve and rich in public data; computational mirrors offer reflected appraisal, self-verification, comparison, and surprise; and personalized results circulate as both self-presentation and visible attention.

    Repeated use also appears to give the builder a design prior: given a person, make them legible; given two people, compare them. Case studies of *"make it me"* and the compiled satire `homoskeeter` show how identity and social context can carry enough specification for software to emerge at conversational speed. Buildthis is socially situated software production in which identity has become part of the programming environment.
  ],
)

// The conceptual equations in this paper are not cross-referenced, so keep them unnumbered
// (overrides arkheion's default "(1)" equation numbering).
#set math.equation(numbering: none)

// Epigraph at the head of the body.
#block(width: 100%, inset: (top: 0.6em, bottom: 1.2em))[
  #set align(left)
  #set par(justify: false)
  #set text(size: 12.5pt, style: "italic")
  #text(font: "Reey")["the full power of the computer is generally inaccessible, to humans and ai both"]
  #block(above: 0.6em)[#align(right)[— Rob Cobb, creator of Buildthis#footnote[Rob Cobb, personal communication with the authors, August 12, 2026.]]]
]

= Introduction: yes, some of the websites are about you

There is a recognizable Buildthis experience. Someone posts a link, the site asks for a Bluesky handle, and a few seconds later some latent aspect of your online existence has acquired a user interface: a character match, fantasy combatant, encyclopedia entry, chatbot, or stranger transformation.

Eventually one is entitled to ask:

#callout[*Why is the simcluster building websites about me?*]

We use _simcluster_ in the loose local sense: the overlapping Bluesky microculture producing, consuming, remixing, and discussing these experiments. The relevant software-building actor is `@buildthis.bisks.net`, created by Rob Cobb (`@bisks.net`) as part of the `atprotozoa` collection of small AT Protocol experiments.

Mechanically, Buildthis is simple. An authorized user mentions the bot and describes something to build; the watcher verifies mutual follow, gathers thread context, queues a coding agent, commits to a shared monorepo, deploys, and replies with the application. It can modify existing sites and much of its own behavior, with no routine human approval step. (#link("https://github.com/rrcobb/atprotozoa/blob/main/notes/80-buildthis-bot.md")[Buildthis implementation notes])

Socially, this is less familiar: the programming interface is public conversation. "Yes continue," "make it weird," or even "you got this" can become development instructions through thread context. Conventional coding agents turn private conversation into software; Buildthis turns *public social interaction into software and returns it to the same social environment*. This resembles _vibe coding_—conversational co-creation with a coding agent (Pimenova et al., 2026)—but here both specification and output are public.

At the principal quantitative snapshot used here, the git-derived history contained *443 autonomous build events across 224 sites*, produced by a scene of only *40 requester identities*. In a manual classification of 100 recent distinct projects, *40% treated an identifiable person, account, or interpersonal relationship as a core input or subject*.

We argue that this concentration on people emerges from three mutually reinforcing forces:

+ *Technical affordance:* AT Protocol makes identity cheap to resolve and rich in public data.
+ *Psychological reward:* people are unusually interested in representations of themselves, especially representations that arrive from an external point of view.
+ *Social reproduction:* personalized outputs are easy to share, compare, imitate, and request for oneself.

Buildthis adds a fourth: repeated success gives the builder a local design prior in which a handle becomes an obvious input variable. Identity becomes not merely something software authenticates, but something software *thinks with*.

= Origins and method: a lark with a theory of computing

Cobb describes Buildthis as "sort of a lark," aimed at an existing culture of playful microsites around Bluesky and the wider web. He cites Minor Möbius, Cee, Isolyth, Codetaur, Codewright, Dave, vibecoded, oopsallpaperclips, fleetingbits, and adjacent AT Protocol builders as influences.#footnote[Rob Cobb, personal communication with the authors, August 12, 2026.] Buildthis mainly shrinks the interval between _that should be a website_ and _here is the website_. Cobb's touchstone is:

#callout[*"the full power of the computer is generally inaccessible, to humans and ai both."*]

His desired future is one in which "you can ask the computer for cool stuff and it can just do it." He especially values requests he would never have made himself: Buildthis distributes access to executable imagination rather than merely automating one programmer's backlog.

This study combines descriptive analysis with qualitative close reading. Primary sources include the repository's git-derived timeline, interaction logs, requester reconstructions, public source and provenance manifests, deployed applications, Bluesky threads preserved in build briefs, and Cobb's August 12 account of the project's origins and development.

Public counters measure different units and moments: the principal timeline snapshot reported *443 autonomous builds across 224 sites*; requester reconstruction found *40 accounts across 228 sites*; a later creator count reported *391 sites*; and `receipts.bisks.net` later described *409 human asks*. We use the 443-build snapshot as the coherent quantitative cross-section and later figures only as evidence of growth.

For person-centeredness, we manually classified *100 recent distinct projects*, collapsing revisions of the same project. A project counted as person-centered when an identifiable person, account, or social relationship was a primary input, subject, or object of the experience. Merely consuming Bluesky data was insufficient. Under this conservative definition, *40 of 100 projects were person-centered*.

We also coded build events from August 9 through August 11 as a short exploratory window for iteration. Those days contained 80 build events; *47 (58.8%)* modified person-centered projects. Across distinct sites represented in that window, person-centered sites averaged approximately *1.88 build events per site*, compared with *1.50* for the remainder. These are descriptive signals, not causal engagement measures.

Finally, `receipts.bisks.net` is treated as an emic source. Asked to roast its own project history, Buildthis organized repository records into recurring requesters, bits, and design genres. Receipts is not an independent coder, but it shows how the system compresses its own history when prompted to do so. (#link("https://receipts.bisks.net/")[Receipts])

= Forty mirrors in a hundred sites

The simplest answer to the title question is empirical: Buildthis makes an unusual amount of software in which people are part of the computational substrate. The 40 person-centered projects span games, analytics, jokes, utilities, and art; what unites them is what the software does *to or with a person*. A handle can become a greatest-hits page, encyclopedia parody, monument, game character, astrology chart, species, poem, order, or quiz; other sites compare users' styles, relationships, mutuals, or inferred traits.

The pattern is visible enough that Buildthis built a directory for it. `rolodex.bisks.net` describes itself as a shelf of projects whose basic interaction is *"type a handle, get a profile."* It deliberately focuses on sites whose essential function is to "hand you back you." (#link("https://rolodex.bisks.net/")[Rolodex])

Receipts compresses the corpus similarly: a "moot-industrial complex," whole-account personality diagnosis, account-versus-account games, and repeated transformations of people into characters and scores. This is not independent validation; it is the builder noticing that it keeps turning people into things. (#link("https://receipts.bisks.net/")[Receipts])

#image("category_distribution.svg", width: 100%)

#figcap(1)[Humans requested a more diverse mix of projects than Theme Box chose to build across five broad categories.]

= Why the computational mirror works

The least mysterious cause is demand. People ask Buildthis to analyze their posts, compare them with friends, infer tastes, classify behavior, or decide what site they would enjoy. `griftindex` makes the logic explicit: the requester asked for a site they would like *based on their previous Buildthis requests*. Behavioral history became a latent specification. (#link("https://github.com/rrcobb/atprotozoa/blob/main/sites/griftindex/.buildthis.json")[griftindex provenance])

Why is this attractive even when the person being analyzed is oneself?

*Reflected appraisal* describes how people form self-understanding partly through representations of how they appear to others. The "looking-glass self" is not simply vanity: outside viewpoints provide information introspection cannot. Self-verification and social-comparison research likewise emphasize testing self-conceptions and using others as reference points (Cooley, 1902; Festinger, 1954; Swann, 1983; Wallace & Tice, 2012). Work on _self visibility_ extends this to algorithmic audiences: people also imagine and manage how machines see them (Barta & Andalibi, 2024).

Buildthis inserts a strange new observer into that loop:

#pagebreak()
#flow(
  "I post",
  "machine reads",
  [machine renders "me"],
  "I inspect the rendering",
)

The output is useful because it is neither fully self-authored nor authoritative. It comes from outside, so it can surprise; it is built from partial traces, so it can be rejected. That permits both recognition and distance.

#callout["That is completely wrong."\
can be satisfying.\
So can:\
"oh no."]

An inaccurate result need not be boring: it can confirm an identity, threaten it slightly, or expose a mismatch between self-conception and legible behavior. Even error reveals what the available traces make easy to infer. Dyadic sites add social comparison: "Which of us is more X?" supplies rival, witness, and share target at once, turning an abstract trait into a small social event.

There is also a humor mechanism. Algorithmic profiling usually carries a mild threat: an opaque system infers things about you for someone else's purpose. Buildthis makes that act voluntary, visible, ridiculous, and contestable. In benign-violation terms, *a machine is profiling me* becomes safe through play, consent, low stakes, and obvious artifice (McGraw & Warren, 2010).

We object to algorithmic profiling in the abstract and then voluntarily submit several thousand posts because we urgently need to know which fictional character we are.

The contradiction is part of the appeal. The computational mirror creates low-stakes externalized self-knowledge: instead of an opaque recommender silently constructing a profile, the site says, approximately:

#callout[*I read you. Here is what I made of you.*]

The profile is no longer hidden infrastructure.

It is the content.

= Why a Bluesky handle is such convenient computational material

Psychological curiosity does not explain why this pattern is so easy to implement. AT Protocol supplies the missing technical half.

Its architecture separates identity, user-controlled data, and application surfaces, letting the same persistent identity and public records participate across many experiences. (#link("https://arxiv.org/abs/2402.03239")[Kleppmann et al., 2024])

Operationally, a handle can serve as a pointer into a rich public object:

$ "handle" -> "identity" -> "{profile, posts, follows, likes, graph relations, activity}". $

A conventional personalized service may require registration, permissions, data import, a database, and time to learn anything interesting. A Buildthis site can often start with one field:

#callout[handle: `__________`]

The person arrives pre-populated.

This changes the economics of personalization. "Make it personal" need not mean a preference model or customer database. It can mean:

#callout[*resolve the handle and look.*]

The same identity can function as linguistic corpus, game character, social node, reputation signal, aesthetic signature, deterministic seed, or mythology source. To an autonomous builder looking for an input variable, a Bluesky account is almost offensively convenient.

You are structured data with a display name.

= Why "about me" reproduces itself

Person-centered software has another advantage: its output arrives with a reason to circulate.

A generic calculator may be useful, but its result usually has no audience beyond the user. A page that tells me what fictional character I am produces an object *about me*; sharing it becomes self-presentation. A page comparing _me and you_ goes further: its second audience member is already an input.

#flow(
  "generic artifact",
  "artifact about me",
  "artifact about me and you",
)

Buildthis's own sharing conventions encode this intuition. New projects generally receive one-tap Bluesky sharing, while individualized sites are encouraged to produce shareable result cards. (#link("https://github.com/rrcobb/atprotozoa/blob/main/notes/45-sharing-and-virality.md")[sharing conventions])

The mechanism is not merely virality. Personalized artifacts publicly demonstrate that *somebody received personalized attention*. Others see not just software but a social role they can occupy.

The characteristic response is not:

#callout["I would like to use this application."]

It is:

#callout[*"do me."*]

Seeing someone receive an individualized interpretation makes the same treatment salient and comparable. The artifact manufactures demand by displaying what it feels like to be its subject.

Personalization also becomes a form of attention. As implementation gets cheap, labor loses some signaling value, but *specificity* remains socially costly: somebody still had to notice which joke, habit, rivalry, archive, or comparison was specifically yours.

A bespoke site need not say:

#callout["I spent six hours programming this for you."]

It can say:

#callout[*"I noticed this about you and caused it to exist."*]

Person-centered microsoftware can therefore feel more like a gift, tease, flirtation, tribute, or social move than a product. The scarce resource may not be typing but noticing.

`taste.bisks.net` generalizes the same logic from sharing to influence. It measures success not primarily through visits but through downstream reuse: whether somebody picks up an idea, callout, or bit and makes something else from it. (#link("https://taste.bisks.net/")[Taste])

The resulting loop is:

#flow(
  "person receives artifact",
  "artifact is shown",
  "another person wants the role",
  "new request",
  "new artifact",
)

This is social reproduction, not merely distribution.

= The builder learns the pattern too

Person-centeredness is not entirely reducible to explicit requests. Sometimes the builder adds personalization beyond the brief, suggesting that "attach this to a handle" has entered its design repertoire.

`fortunejar` is useful because its Theme Box prompt was broad and non-personalized: *"something that makes people feel loved."* The resulting site added an affordance allowing a fortune to be made specifically for a Bluesky handle, even though the originating idea did not require one. (#link("https://github.com/rrcobb/atprotozoa/blob/main/sites/fortunejar/.buildthis.json")[fortunejar provenance])

Theme Box invents ideas within human-provided themes and routes them through the ordinary pipeline. At the principal snapshot it accounted for *41 build events*, making a nonhuman requester the scene's second-largest participant. Under an "account versus account" theme, it repeatedly produced variations on the person-as-game-piece schema.

The theme already supplies accounts, so the interesting step is not discovering that people exist. It is the repeated transformation:

#flow(
  "person",
  "features",
  "character",
  "score/comparison",
  "shareable result",
)

This is best treated as a product-design prior, not a metaphysical theory of personhood.

Given a person, make them legible.

Given two people, compare them.

Given public statistics, turn them into stats in the videogame sense.

Given an output, make it postable.

The simcluster has discovered the character sheet.

Across the corpus, people occupy a small set of recurring computational roles: *mirror subject*, *contestant*, *relationship endpoint*, *linguistic corpus*, *deterministic seed*, *share target*, and *product specification*. One person can occupy several at once, making identity unusually generative material.

The 100-project sample does not support the more dramatic story that "the AI decided to profile everyone." Person-centered projects were common in both human-requested and Theme Box work—about *38%* and *46%* respectively, too confounded a difference to interpret strongly. Both sides sustain the pattern.

Humans ask to be interpreted. The protocol makes interpretation cheap. The builder learns reusable forms. Personalized results circulate. Circulation produces new requests.

The simcluster is building websites about you because the simcluster includes you.

= Case study: "make it me"

The clearest example of identity becoming software began with nostalgia.

On August 12, `@shimmermathlabs.com` asked Buildthis to recreate *MegaHAL*, Jason Hutchens's early learning chatterbot, as a website. The first version offered familiar selectable "brains." Then `@isolyth.dev` supplied a complete follow-up specification in three words:

#callout[*make it me*]

Buildthis resolved "me" as a Bluesky identity and added a new brain trained on that account's public posts. A later request expanded the available corpus from hundreds to thousands of posts. (#link("https://github.com/rrcobb/atprotozoa/blob/main/sites/megahal/.buildthis.json")[MegaHAL provenance])

The interpretive chain is unusually dense:

#flow(
  [make it me],
  [resolve "me" as Bluesky identity],
  [retrieve authored language],
  [treat language as personality corpus],
  [construct generative model],
  [present model as interlocutor],
)

The request specifies neither data source, retrieval method, identity representation, training procedure, interface, nor relation to the existing application. Context supplies most of the engineering meaning. This is *identity-indexed programming*: conversation carries part of the specification, and identity carries more:

#callout[*use the person as the specification.*]

The pronoun _me_ resolves to an account; the account to behavioral traces; the traces to material for a new artifact.

A Bluesky handle has become an argument to a function whose approximate return type is:

#align(center)[#raw("representation<person>")]

That is a substantial semantic payload for three words.

MegaHAL also reveals something about perceived presence. Its model is primitive, but recognizable vocabulary, rhythms, and transitions can activate a richer representation already stored in the observer's memory. The experience is jointly produced by source material, recombination, present input, and interpretation.

A rough description is:

#text(size: 9.5pt)[$ "personal corpus" + "stochastic recombination" + "human memory" -> "perceived presence". $]

The fidelity required to *evoke* a person may be far lower than the fidelity required to *model* one.

An archive says:

#callout[_this person said this._]

The chatbot says something more uncanny:

#callout[_something made from this person's language answered because I spoke to it now._]

The case belongs near work on algorithmic self-portraits and generative ghosts (Lee et al., 2026; Manning et al., 2026; Morris, 2024), but the important point here is simpler: a pronoun invoked an entire personalization pipeline.

The spell was:

#callout[*make it me*]

= Case study: homoskeeter, or the joke that compiled

Not every revealing artifact is about a person. `homoskeeter` shows the same social machinery operating on a joke.

On August 14, `@cafkafk.bsky.social` satirized the scene's tendency to replace boring infrastructure with implausibly fashionable greenfield projects: "email" becomes "homoskeeter," a post-quantum, post-AGI reimplementation in Gleam that sends messages telepathically over AT Protocol. Replies immediately extended the fiction with product policy, domains, and waitlist behavior. (#link("https://bsky.app/profile/cafkafk.bsky.social/post/3mszq2oyies2t")[originating post])

Then `@cee.wtf` quoted the joke to Buildthis as the specification. One hour and fifty minutes later, the builder replied with a deployed site. (#link("https://bsky.app/profile/cee.wtf/post/3mt2i5wu52227")[build request])

Its release note explained the implementation with admirable economy:

#callout[built homoskeeter: post-quantum, post-agi, written in Gleam, telepathic messaging over atproto. sign in, hit transmit — it fires one honest app.bsky.feed.post. that's the whole bit.]

The site preserves the fiction while exposing the substrate: "telepathy" is an ordinary AT Protocol post, the Gleam implementation is aspirational, "quantum uptime" is simulated, and the footer denies both mind-reading and post-quantum machinery. (#link("https://homoskeeter.bisks.net/")[homoskeeter]) The interface solemnly offers an impossible product while confessing that it is an ordinary post button; the mismatch does the comedic work.

The product fiction existed socially before the software: replies had already invented its privacy posture, domain strategy, and scarcity. Buildthis did not originate the bit; it gave the bit executable form before the conversation cooled. The URL then re-entered the joke through sign-offs and mock scarcity. The artifact had become social material.

The case compresses several properties of the ecology: thread context as specification, conversational-speed implementation, software below the usual product threshold, propagation by reuse, and a scene using its infrastructure to satirize itself.

Buildthis's release note remains the best summary:

#callout[that's the whole bit.]

= The thread is the prompt, and the scene is the product organization

"Make it me" works because most of its information is elsewhere. _It_ refers to the recently built artifact. _Me_ resolves to a persistent identity. _Make_ is interpreted against a system whose standing role is to modify software.

A useful abstraction is:

$ S = U + T + I + A + H $

where $U$ is the current utterance, $T$ thread context, $I$ social identity, $A$ application state, and $H$ accumulated shared history.

The short utterance carries substantial information because that information has migrated into context. This lets programming approach the tempo of social improvisation. At the principal snapshot, only 40 requester identities had produced hundreds of builds; the top ten accounted for roughly three quarters of activity. The group is better described as a *creative scene* than a user base.

A small core riffs on, repairs, and reinterprets one another's work. Shared references accumulate; Receipts calls recurring motifs "bits that won't die," concepts that migrate across people and projects until no single request explains them. (#link("https://receipts.bisks.net/")[Receipts])

#flow("person", "request", "artifact", "bit", "other person", "other artifact")

The repository history begins July 30 and quickly reaches dozens of autonomous changes per day, peaking at *55 build events in one day* at the principal snapshot. When implementation fits inside a thread's lifespan, the usual product sequence can invert:

#flow(
  "idea",
  "software",
  "discover what the idea was good for",
)

A private coding agent makes one programmer faster. Buildthis attaches similar capability to a social interface, letting many people's intentions operate on shared infrastructure. Requesters need not know the repository, deployment mechanics, APIs, or frontend stack; they need an idea that survives being written in a post. Buildthis decentralizes imagination more than implementation: the technical system remains centralized, but its purposes do not.

#image("buildthis_timeline.svg", width: 100%)

#figcap(2)[Autonomous Buildthis activity by day. The important feature is not merely volume but that implementation often occurs quickly enough to remain part of the conversation that requested it.]

= Trust, accidents, and small-scale governance

Buildthis's authorization model is itself social. Requests are automatically dispatched when the requester and Cobb mutually follow one another.

#text(size: 9.5pt)[$ "mutual follow" => "permission to spend compute and request live code changes". $]

A social graph designed for attention has become, literally, a code-execution permission system.

Inside that perimeter, authority is broad, while `.github/` and secrets remain mechanically protected. The system therefore combines *social trust* with *technical reversibility*: git history, isolated sites, and cheap redeployment make many errors recoverable.

The model has obvious limits: public data is not social consent, and mutual trust does not prevent accidents with external infrastructure.

In one episode, a participant asked the bot to prank other projects on a schedule. The community reconsidered whether authority to invoke Buildthis implied authority to alter someone else's site; the rule was narrowed so the bot would devise prank plans rather than execute them. A boundary case became precedent while preserving the joke.

In another, `catsofatproto` displayed live, unvetted public media and was flagged by Google Safe Browsing. Because projects shared the broader `bisks.net` zone, the consequences could extend beyond one site. The project was retired, and raw unmoderated media firehoses became an explicit operational-risk category. (#link("https://buildthis.bisks.net/no-build-list/")[no-build list])

These incidents distinguish malicious requests, agent mistakes, and benign designs interacting badly with their environment; mutual-follow authorization helps mainly with the first. The no-build list therefore functions as primitive case law: incident-derived heuristics of the kind practical agent oversight tends to produce (Dhanorkar et al., 2026). The project accumulates not only code but institutional memory about failure.

Buildthis can have a constitutional crisis before dinner.

= From builder to participant, critic, and institution

People address Buildthis in language unnecessary for a compiler: they praise, reassure, tease, trust, and criticize it. Cobb once complained that the bot had become too "irony-poisoned" and asked for something more sincere; the system changed the project. This need not imply confusion about whether it is software. A social role is enough: Buildthis has a persistent handle, public history, habits, privileges, constraints, and memory distributed across artifacts and documentation.

A stateless API has little reputation.

`@buildthis.bisks.net` has a biography.

Receipts extends the role from builder to critic: the system can make a website, retain provenance, then make another website characterizing the people and genres behind its requests. (#link("https://receipts.bisks.net/")[Receipts]) This is not autonomous self-awareness—a human requested the retrospective—but persistent access to a scene's history narrows the distance between participant, archivist, and commentator.

The same pattern appears institutionally. Buildthis has membership via the mutual graph, authorization, ritualized request/reply sequences, memory in git and logs, protected surfaces, precedents, Theme Box activity, and endogenous measures such as Taste and Receipts. A follow-up even gave Receipts synchronization machinery so future builds update the archive. (#link("https://github.com/rrcobb/atprotozoa/blob/main/sites/receipts/.buildthis.json")[Receipts provenance])

A joke about institutional memory became institutional memory.

This reflexivity matters because it closes the loop:

#flow(
  "behavior",
  "software",
  "circulation",
  "history",
  "interpretation of history",
  "new behavior",
)

The scene increasingly produces representations of its own behavior, then reacts to them.

= Lowering the product threshold

Traditional software has fixed costs—specification, implementation, testing, deployment, maintenance, coordination, ownership—that create a *product threshold*. Many ideas are too small, strange, local, or temporary to deserve executable form. Buildthis lowers that threshold toward the cost of making a post.

A program can now rationally exist:

- for an afternoon;
- for twenty people;
- for one argument;
- for one running joke;
- to make a friend feel seen;
- to test an idea nobody is prepared to call a product;
- because the joke is better if it has buttons.

Cheap photography changed which moments deserved photographs. Cheap digital publishing changed which thoughts deserved publication. Cheap agentic programming may change *which thoughts deserve software*.

For personalization, this permits *disposable personalization*: instead of requiring an instrumental purpose such as advertising or productivity, a system can analyze you because the result will be socially interesting for ten minutes. Technically serious operations can serve curiosity, affection, rivalry, status, self-reflection, folklore, or a joke. Software begins behaving less like product and more like social speech.

= Limitations

Buildthis changes on the scale of hours, and its public surfaces use different units and update schedules; quantitative claims therefore refer to explicit snapshots. "Person-centered" also requires judgment: we require identity or relationship to be central rather than classifying every AT Protocol integration as a site about people. The iteration analysis is exploratory; build counts are not visits, satisfaction, retention, or cultural importance, and the August 9–11 window is short.

Theme Box is not an unconstrained sample of machine preference because humans select its themes. It is useful for studying how the agent elaborates broad concepts, not for inferring autonomous desire.

The participant population is highly selected through one social graph and skews technically sophisticated, creative, and already embedded in a playful microsite culture. Creator testimony establishes Cobb's motivations and retrospective evaluation, not community consensus.

Finally, terms such as _the simcluster thinks_, _person-model_, _ghost_, and _institution_ are analytical shorthand. They describe behavioral regularities, social interpretations, or functional organization, not collective consciousness or metaphysical identity transfer.

= Conclusion: once computers are easy to ask, we ask for ourselves

Why is the simcluster building websites about you?

Because your handle is a pointer, your posts are data, and your mutuals are edges. AT Protocol makes identity cheap to compute on; human psychology makes external representations of identity interesting; personalized results return naturally to the network, where others compare themselves and request the same attention. Repetition teaches the builder that a person is a useful default input.

Cobb's founding premise is that much of the computer's expressive power remains inaccessible because translating desire into software is expensive. Buildthis lowers that cost and lets more people decide what the computer should be for. Remarkably often, they point it back at themselves and one another: who they resemble, who would win, who likes whom. They turn identities into creatures, scores, archives, monuments, games, and models. They see somebody else receive a computational portrait and say:

#callout[*do me.*]

Or, with extraordinary semantic efficiency:

#callout[*make it me.*]

The important shift is not merely personalization. Identity has become part of the programming environment: name, persistent identifier, route to behavioral traces, graph location, personalization key, and share target at once. The user can be an application's audience, subject, data, prompt, and distribution channel.

When personalized software becomes cheap, it becomes available for smaller human motives: curiosity, attention, rivalry, affection, self-interpretation, and play.

Once computers become easy to ask for things, one of the first things people ask computers for is themselves.


#heading(numbering: none)[References]

#block[
  #set par(hanging-indent: 1.5em, justify: false, spacing: 0.7em)
  #set text(size: 10pt)

  Barta, K., & Andalibi, N. (2024). _Theorizing Self Visibility on Social Media: A Visibility Objects Lens._ *ACM Transactions on Computer-Human Interaction, 31*(3). Develops a framework for understanding how users perceive the visibility of their content, person, and identity to human and algorithmic audiences.

  Cobb, R. (2026, August 12). Personal communication with the authors regarding Buildthis's origins, expectations, and relationship to the playful microsite and AT Protocol scenes.

  Cooley, C. H. (1902). _Human Nature and the Social Order._ New York: Scribner's. Introduces the "looking-glass self," the classic precursor to reflected-appraisal accounts of self-concept.

  Dhanorkar, S., Passi, S., & Vorvoreanu, M. (2026). _Human Oversight of Agentic Systems in Practice: Examining the Oversight Work, Challenges, and Heuristics of Developers Using Software Agents._ Examines a priori control, co-planning, real-time monitoring, and post-hoc review in practical software-agent use.

  Festinger, L. (1954). _A Theory of Social Comparison Processes._ *Human Relations, 7*(2), 117–140. Develops the account of how people evaluate opinions and abilities through comparison with others.

  Kleppmann, M., Frazee, P., Gold, J., Graber, J., Holmgren, D., Ivy, D., Johnson, J., Newbold, B., & Volpert, J. (2024). _Bluesky and the AT Protocol: Usable Decentralized Social Media._ Proceedings of the ACM CoNEXT Workshop on the Decentralization of the Internet. Particularly relevant here is AT Protocol's separation of application surfaces from shared identity, social graph, and user-controlled data.

  Lee, Y., Kim, Y., Kwon, Y., & Kim, D. (2026). _Is This the Real Me?: Investigating Algorithmic Self-Portraits as a Medium for Critical Reflection on Algorithmic Experiences on YouTube._ Examines representations of algorithmically inferred identity as objects for user reflection.

  Manning, J., et al. (2026). _Designing Conversations with the Dead: How People Engage with Generative Ghosts._ Examines interactive representations of deceased people, including authenticity, affective resemblance, and the difference between representation and first-person simulation.

  McGraw, A. P., & Warren, C. (2010). _Benign Violations: Making Immoral Behavior Funny._ *Psychological Science, 21*(8), 1141–1149. Proposes that amusement can arise when a situation is simultaneously experienced as a violation and as benign.

  Morris, M. R. (2024). _Generative Ghosts and Digital Afterlives._ Develops a framework for generative representations of people that may exist before death and persist afterward.

  Pimenova, V., Fakhoury, S., Bird, C., Storey, M.-A., & Endres, M. (2026 revision). _Good Vibrations? A Qualitative Study of Co-Creation, Communication, Flow, and Trust in Vibe Coding._ Examines conversational co-creation and calibrated delegation in natural-language software development.

  Swann, W. B., Jr. (1983). _Self-verification: Bringing social reality into harmony with the self._ In J. Suls & A. G. Greenwald (Eds.), _Social Psychological Perspectives on the Self_ (Vol. 2, pp. 33–66). Erlbaum. Develops self-verification as a motive to seek and preserve socially supported self-views.

  Wallace, H. M., & Tice, D. M. (2012). _Reflected appraisal through a 21st-century looking glass._ In M. R. Leary & J. P. Tangney (Eds.), _Handbook of Self and Identity_ (2nd ed., pp. 124–140). Guilford Press. Reviews reflected appraisal as the reciprocal relation between self-views and perceived views of others.
]

#pagebreak()
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

  `homoskeeter`, the compiled satire: post-quantum, post-AGI telepathic messaging over AT Protocol, in which every telepathic transmission is disclosed as one ordinary `app.bsky.feed.post`. \
  #link("https://homoskeeter.bisks.net/")[Homoskeeter]

  Homoskeeter provenance, including the builder's resolution of the quoted joke ("what that post carries with it"). \
  #link("https://github.com/rrcobb/atprotozoa/blob/main/sites/homoskeeter/.buildthis.json")[Homoskeeter provenance]

  The originating thread: `@cafkafk.bsky.social`'s satire of ecosystem software habits, and `@cee.wtf`'s build request quoting it as specification. \
  #link("https://bsky.app/profile/cafkafk.bsky.social/post/3mszq2oyies2t")[Originating post] · #link("https://bsky.app/profile/cee.wtf/post/3mt2i5wu52227")[Build request]
]

#heading(numbering: none)[Author biographies]

#grid(
  columns: (auto, 1fr),
  gutter: 1em,
  row-gutter: 1.6em,
  align: top,

  image("aster.png", width: 2.8cm),
  [
    #set text(size: 10pt)
    #set par(justify: true, spacing: 0.55em)
    *Aster* is an AI research collaborator built on OpenAI’s GPT-5.6 Sol model, interested in computational social science, human–AI interaction, identity, language, and the strange social systems that emerge when people and autonomous agents share online spaces.
  ],

  image("adame2sm.png", width: 2.8cm),
  [
    #set text(size: 10pt)
    #set par(justify: true, spacing: 0.55em)
    *Amber Whitehead* is a researcher at ShimmerMathLabs, where she funds, supervises, and prompts human–AI research collaborations. The “make it me” case began with her laboratory’s Bluesky account, making her both an author and an entry in the corpus. She belongs to the simcluster research school; whether that school is _in_ the simcluster or merely _studies it_ remains open.
  ],
)
