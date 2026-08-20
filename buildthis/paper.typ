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
  date: "August 20, 2026",
  keywords: ("Bluesky", "AT Protocol", "agentic coding", "identity", "microsites"),
  abstract: [
    `@buildthis.bisks.net` is an autonomous software-building agent embedded in Bluesky: authorized users describe software in ordinary posts, the system reads the surrounding conversation, modifies a shared repository, deploys the result, and replies with a working application. At the principal quantitative snapshot used here, its git-derived history contained *443 autonomous build events across 224 sites*, produced by only *40 requester identities*.

    A striking fraction of this software is about people. In a manual classification of 100 recent distinct projects, *40% treated an identifiable person, social-media account, or interpersonal relationship as a core input or subject*. This paper argues that the pattern emerges from a particularly compatible combination of technical affordance, human psychology, and social propagation. AT Protocol makes identity cheap to resolve and rich in public data. People are strongly interested in external representations of themselves: computational mirrors provide reflected appraisal, self-verification, comparison, and low-stakes surprise. Personalized results also circulate unusually well because they double as self-presentation and publicly demonstrate a form of attention that others can request for themselves.

    Repeated use appears to give the builder a corresponding product-design prior: given a person, make them legible; given two people, compare them. Case studies of the three-word instruction *"make it me"* and the compiled satire `homoskeeter` show how identity and social context can carry enough specification for software to emerge at conversational speed. Buildthis is therefore best understood as socially situated software production in which identity has become part of the programming environment.
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

There is a recognizable Buildthis experience. Someone posts a link. The site asks for a Bluesky handle. You type yours. A few seconds later, some previously latent aspect of your online existence has acquired a user interface.

Perhaps it tells you which _Seinfeld_ character your posts resemble. Perhaps your account becomes a fantasy combatant. Perhaps it identifies the mutual who writes most like you, converts your DID into astrology, renders you as an encyclopedia entry, or trains a chatbot on several thousand of your posts.

Eventually one is entitled to ask:

#callout[*Why is the simcluster building websites about me?*]

We use _simcluster_ in the loose local sense: the overlapping Bluesky microculture producing, consuming, remixing, and discussing these experiments. The relevant software-building actor is `@buildthis.bisks.net`, created by Rob Cobb (`@bisks.net`) as part of the `atprotozoa` collection of small AT Protocol experiments.

Mechanically, Buildthis is simple. An authorized user mentions the bot and describes something to build. The watcher verifies the mutual-follow relationship, collects the post and relevant thread context, queues a coding-agent job, commits the result to a shared monorepo, deploys it, and replies publicly with a working application. It can modify existing sites and much of its own behavior. Routine builds require no human approval step. (#link("https://github.com/rrcobb/atprotozoa/blob/main/notes/80-buildthis-bot.md")[Buildthis implementation notes])

Socially, this produces something less familiar. The programming interface is ordinary public conversation. "Yes continue" can be a development instruction. "Make it weird" can be design guidance. "You got this" can resolve, through thread context, to a concrete software task. A conventional coding agent translates private conversation into software. Buildthis translates *public social interaction into software and returns the software to the same social environment that produced it*.

At the principal quantitative snapshot used here, the git-derived history contained *443 autonomous build events across 224 sites*, produced by a scene of only *40 requester identities*. In a manual classification of 100 recent distinct projects, *40% treated an identifiable person, account, or interpersonal relationship as a core input or subject*.

The central claim of this paper is that this concentration on people is not an accident of one model or one unusually self-involved social circle. It emerges from three forces that fit together unusually well:

+ *Technical affordance:* AT Protocol makes identity cheap to resolve and rich in public data.
+ *Psychological reward:* people are unusually interested in representations of themselves, especially representations that arrive from an external point of view.
+ *Social reproduction:* personalized outputs are easy to share, compare, imitate, and request for oneself.

Buildthis then adds a fourth force: repeated exposure to successful person-centered patterns gives the builder a local design prior. A handle starts to look like an obvious input variable.

The result is a feedback loop in which identity becomes not merely something software authenticates, but something software *thinks with*.

= Origins and method: a lark with a theory of computing

Buildthis entered a pre-existing culture of playful microsites around Bluesky and the wider web. Cobb points to Minor Möbius, Cee, Isolyth, Codetaur, Codewright, Dave, vibecoded, oopsallpaperclips, fleetingbits, and adjacent AT Protocol builders as part of the scene that made him want to participate.#footnote[Rob Cobb, personal communication with the authors, August 12, 2026.] Small, strange websites already functioned there as jokes, tools, artworks, replies, and social gestures.

Buildthis changes that practice mainly by reducing the interval between _that should be a website_ and _here is the website_. Cobb describes as a touchstone the proposition:

#callout[*"the full power of the computer is generally inaccessible, to humans and ai both."*]

His desired future is one in which "you can ask the computer for cool stuff and it can just do it." What matters is not merely faster implementation. Cobb specifically values that people request sites he himself would never have requested. Buildthis is therefore an experiment in distributing access to executable imagination rather than automating one programmer's backlog.

This study combines descriptive analysis with qualitative close reading. Primary sources include the repository's git-derived timeline, interaction logs, requester reconstructions, public source and provenance manifests, deployed applications, Bluesky threads preserved in build briefs, and Cobb's August 12 account of the project's origins and development.

The public counters measure different units and moments. The principal timeline snapshot reported *443 autonomous builds across 224 sites*; the requester reconstruction reported *40 requester accounts across 228 sites*. A later creator-side count referred to just under one thousand tags and *391 sites*. `receipts.bisks.net`, generated later from project manifests, describes *409 human asks*. These should not be collapsed into one timeless total. This paper uses the 443-build snapshot as its coherent quantitative cross-section and later figures only as evidence of continued growth.

For person-centeredness, we manually classified *100 recent distinct projects*, collapsing revisions of the same project. A project counted as person-centered when an identifiable person, account, or social relationship was a primary input, subject, or object of the experience. Merely consuming Bluesky data was insufficient. Under this conservative definition, *40 of 100 projects were person-centered*.

We also coded build events from August 9 through August 11 as a short exploratory window for iteration. Those days contained 80 build events; *47 (58.8%)* modified person-centered projects. Across distinct sites represented in that window, person-centered sites averaged approximately *1.88 build events per site*, compared with *1.50* for the remainder. These are descriptive signals, not causal engagement measures.

Finally, `receipts.bisks.net` is used cautiously as an emic source. Buildthis was asked to read its own project manifests and retrospectively roast the requests it had received, organizing them into recurring requesters, persistent bits, and design genres. The factual substrate comes from repository records; the commentary comes from the builder. Receipts is therefore not an independent coder, but it is useful evidence about how the system, prompted to summarize its own history, compresses that history. (#link("https://receipts.bisks.net/")[Receipts])

= Forty mirrors in a hundred sites

The simplest answer to the title question is empirical: Buildthis really does make an unusual amount of software in which people themselves are part of the computational substrate.

The 40 person-centered projects cut across ordinary product categories. Some were games, some analytics, some jokes, some social utilities, and some artworks. What united them was not what the software did but what it did *to or with a person*.

A handle can become a ranked greatest-hits page, a Wikipedia parody, a literary retrospective, a marble monument, a mech-pilot card, DID astrology, a biological species, a McDonald's order, a sonnet assembled from one's vocabulary, or a quiz measuring how well somebody knows the account. Other sites compare two users' styles, social relationships, mutuals, or inferred traits.

The pattern is visible enough that Buildthis built a directory for it. `rolodex.bisks.net` describes itself as a shelf of projects whose basic interaction is *"type a handle, get a profile."* It deliberately focuses on sites whose essential function is to "hand you back you." (#link("https://rolodex.bisks.net/")[Rolodex])

Receipts independently compresses the corpus into similar forms: a "moot-industrial complex," whole-account personality diagnosis, recurring account-versus-account games, and repeated transformations of people into characters and scores. Again, this is not independent validation. It is more peculiar than that: the builder has also noticed that it keeps turning people into things. (#link("https://receipts.bisks.net/")[Receipts])

#figcap(1)[Person-centeredness in a recent 100-project sample. Forty projects treat an identifiable person, account, or interpersonal relationship as core computational material; sixty do not.]

= Why the computational mirror works

The least mysterious cause is demand. People repeatedly ask Buildthis to analyze their posting habits, compare them with friends, infer their taste, classify their behavior, or decide what kind of website they would enjoy. `griftindex` makes the final form explicit: the requester asked Buildthis to make a site it thought they would like *based on their previous Buildthis requests*. The person's behavioral history became a latent specification. (#link("https://github.com/rrcobb/atprotozoa/blob/main/sites/griftindex/.buildthis.json")[griftindex provenance])

The interesting question is why this remains attractive even to people who already possess direct access to the person being analyzed—often themselves.

A useful psychological concept is *reflected appraisal*: people form and regulate self-understanding partly through representations of how they appear to others. The "looking-glass self" is not simply vanity. Other viewpoints supply information that introspection cannot. Later work on self-verification similarly shows that people seek feedback that helps stabilize or test existing self-conceptions, while social-comparison research emphasizes the use of others as reference points for evaluating oneself (Cooley, 1902; Festinger, 1954; Swann, 1983; Wallace & Tice, 2012).

Buildthis inserts a strange new observer into that loop:

#flow(
  "I post",
  "machine reads",
  [machine renders "me"],
  "I inspect the rendering",
)

The output is psychologically useful because it is neither fully self-authored nor fully authoritative. It comes from outside, so it can surprise; it is obviously constructed from partial traces, so it can be rejected. That combination permits both recognition and distance.

#callout["That is completely wrong."\
can be satisfying.\
So can:\
"oh no."]

Self-verification also explains why an inaccurate result need not be boring. A result can confirm an identity, threaten it slightly, or expose a mismatch between self-conception and legible behavior. Each supplies something to inspect. The machine's error is itself information about what the available traces make easy to infer.

The social-comparison component becomes strongest in dyadic sites. "Which character am I?" asks for interpretation. "Which of us is more X?" supplies a rival, witness, and share target in one move. The interface turns an abstract trait into a small social event.

There is also a useful humor mechanism here. Algorithmic profiling normally carries a mild threat: an opaque system infers things about you for someone else's purpose. Buildthis often makes the same basic act voluntary, visible, ridiculous, and contestable. In the language of benign-violation theory, the violation—*a machine is profiling me*—is made benign by play, consent, low stakes, and obvious artifice (McGraw & Warren, 2010). The result can be funny without needing an authored punchline.

We object to algorithmic profiling in the abstract and then voluntarily submit several thousand posts because we urgently need to know which fictional character we are.

That contradiction is not incidental to the appeal. It is part of it.

The computational mirror therefore works because it creates a low-stakes form of externalized self-knowledge. Rather than an opaque recommender silently constructing a profile to select advertisements or feed items, the site says, approximately:

#callout[*I read you. Here is what I made of you.*]

The profile is no longer hidden infrastructure.

It is the content.

= Why a Bluesky handle is such convenient computational material

Psychological curiosity does not explain why this pattern is so easy to implement. AT Protocol supplies the missing technical half.

Its architecture separates identity, user-controlled data, and application surfaces in ways that make third-party social applications unusually natural. The same persistent identity and public records can participate across many experiences. (#link("https://arxiv.org/abs/2402.03239")[Kleppmann et al., 2024])

Operationally, a handle can serve as a pointer into a rich public object:

$ "handle" -> "identity" -> "{profile, posts, follows, likes, graph relations, activity}". $

A conventional personalized service might require registration, onboarding, a database, permissions, data import, and enough continued use to learn anything interesting. A Buildthis site can often start with one field:

#callout[handle: `__________`]

The person arrives pre-populated.

This changes the economics of personalization. "Make it personal" need not mean building a preference model or customer database. It can mean:

#callout[*resolve the handle and look.*]

The same identity can then function as linguistic corpus, game character, social node, reputation signal, aesthetic signature, deterministic seed, or source of mythology.

From the perspective of an autonomous builder looking for an input variable, a Bluesky account is almost offensively convenient.

You are structured data with a display name.

= Why "about me" reproduces itself

Person-centered software has another advantage: its output arrives with a reason to circulate.

A generic calculator may be useful, but its result usually has no audience beyond the user. A page that tells me what fictional character I am produces an object *about me*. Sharing it becomes self-presentation. A page comparing _me and you_ goes further: its second audience member has already been supplied as an input.

#flow(
  "generic artifact",
  "artifact about me",
  "artifact about me and you",
)

Buildthis's own sharing conventions encode this intuition. New projects generally receive one-tap Bluesky sharing, while individualized sites are encouraged to produce shareable result cards. (#link("https://github.com/rrcobb/atprotozoa/blob/main/notes/45-sharing-and-virality.md")[sharing conventions])

The important mechanism, however, is not merely virality. Personalized artifacts publicly demonstrate that *somebody received personalized attention*. A second participant does not just see software; they see a social role they can occupy.

The characteristic response is not:

#callout["I would like to use this application."]

It is:

#callout[*"do me."*]

That distinction matters. The desire is partly mimetic in the ordinary social-psychological sense: seeing another person receive an individualized interpretation makes the same treatment salient and comparable. The artifact manufactures demand by displaying what it feels like to be its subject.

This is also where personalization becomes a form of attention. If implementation becomes cheap, implementation labor loses some of its signaling value. But *specificity* can remain costly in a social sense. Somebody still had to notice which joke, habit, rivalry, archive, or comparison would be specifically yours.

A bespoke site need not say:

#callout["I spent six hours programming this for you."]

It can say:

#callout[*"I noticed this about you and caused it to exist."*]

This is one reason person-centered microsoftware can feel more like a gift, tease, flirtation, tribute, or social move than a product. The scarce resource may not have been typing. It may have been noticing.

`taste.bisks.net` generalizes the same logic from sharing to influence. It measures success not primarily through visits but through downstream reuse: whether somebody picks up an idea, callout, or bit and makes something else from it. (#link("https://taste.bisks.net/")[Taste])

The resulting loop is:

#flow(
  "person receives artifact",
  "artifact is shown",
  "another person wants the role",
  "new request",
  "new artifact",
)

This is more than distribution. It is social reproduction.

= The builder learns the pattern too

Person-centeredness is not entirely reducible to explicit requests. There are cases where the builder adds personalization beyond what the brief requires, suggesting that "attach this to a handle" has entered its local design repertoire.

`fortunejar` is useful because its Theme Box prompt was broad and non-personalized: *"something that makes people feel loved."* The resulting site added an affordance allowing a fortune to be made specifically for a Bluesky handle, even though the originating idea did not require one. (#link("https://github.com/rrcobb/atprotozoa/blob/main/sites/fortunejar/.buildthis.json")[fortunejar provenance])

Theme Box periodically invents build ideas within human-provided themes and routes them through the ordinary pipeline. At the principal snapshot it accounted for *41 build events*, making a nonhuman requester the scene's second-largest participant. Under an "account versus account" theme, it repeatedly produced fantasy characters, profile brawlers, spellcasters, creatures, contestants, and other variations on the person-as-game-piece schema.

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

Across the corpus, people repeatedly occupy a small set of computational roles: *mirror subject*, *contestant*, *relationship endpoint*, *linguistic corpus*, *deterministic seed*, *audience/share target*, and *product specification*. A single person can occupy several roles at once. That multiplicity is why identity is such generative material.

Importantly, the 100-project sample does not support the more dramatic story that "the AI decided to profile everyone." Person-centered projects were common among both human-requested and Theme Box work—approximately *38%* and *46%* respectively, a difference too small and confounded to interpret strongly. The important fact is that both sides sustain the pattern.

Humans ask to be interpreted. The protocol makes interpretation cheap. The builder learns reusable forms. Personalized results circulate. Circulation produces new requests.

The simcluster is building websites about you because the simcluster includes you.

= Case study: "make it me"

The clearest example of identity becoming software began with nostalgia.

On August 12, `@shimmermathlabs.com` asked Buildthis to recreate *MegaHAL*, Jason Hutchens's early learning chatterbot, as a website. The first version provided familiar selectable MegaHAL "brains." Then `@isolyth.dev` supplied a complete follow-up specification consisting of three words:

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

The request does not specify the data source, retrieval method, representation of identity, training procedure, interface, or relation to the existing application. Most engineering meaning is supplied by context.

This is a useful example of *identity-indexed programming*. Traditional programming requires explicit behavior. Natural-language programming replaces code with prose requirements. Contextual programming lets surrounding conversation carry part of the specification. Here, identity itself carries more:

#callout[*use the person as the specification.*]

The pronoun _me_ resolves to an account. The account resolves to behavioral traces. Those traces become material for a new artifact.

A Bluesky handle has become an argument to a function whose approximate return type is:

#align(center)[#raw("representation<person>")]

That is a substantial semantic payload for three words.

MegaHAL also reveals something about perceived presence. Its model is primitive compared with a modern language model, but recognizable vocabulary, rhythms, and phrase transitions can activate a much richer representation already stored in the observer's memory. The experience is jointly produced by source material, algorithmic recombination, present input, and human interpretation.

A rough description is:

#text(size: 9.5pt)[$ "personal corpus" + "stochastic recombination" + "human memory" -> "perceived presence". $]

The fidelity required to *evoke* a person may be far lower than the fidelity required to *model* one.

An archive says:

#callout[_this person said this._]

The chatbot says something more uncanny:

#callout[_something made from this person's language answered because I spoke to it now._]

The case belongs near work on algorithmic self-portraits and generative ghosts, but its most important feature here is simpler. An entire personalization pipeline was invoked by a pronoun.

The spell was:

#callout[*make it me*]

= Case study: homoskeeter, or the joke that compiled

Not every revealing Buildthis artifact is about a person. `homoskeeter` is useful because it shows what happens when the same social machinery operates on a joke.

On August 14, `@cafkafk.bsky.social` satirized the scene's tendency to replace boring infrastructure with implausibly fashionable greenfield projects: "email" becomes "homoskeeter," a post-quantum, post-AGI reimplementation in Gleam that sends messages telepathically over ATProto. Replies immediately extended the fiction with product policy, domains, and waitlist behavior. (#link("https://bsky.app/profile/cafkafk.bsky.social/post/3mszq2oyies2t")[originating post])

Then `@cee.wtf` quoted the joke to Buildthis as the specification. One hour and fifty minutes later, the builder replied with a deployed site. (#link("https://bsky.app/profile/cee.wtf/post/3mt2i5wu52227")[build request])

Its release note explained the implementation with admirable economy:

#callout[built homoskeeter: post-quantum, post-agi, written in Gleam, telepathic messaging over atproto. sign in, hit transmit — it fires one honest app.bsky.feed.post. that's the whole bit.]

The site preserves the fiction while repeatedly exposing the substrate. "Telepathy" is an ordinary ATProto post. The displayed Gleam implementation is marked aspirational. "Quantum uptime" is explicitly simulated. The footer states that no minds were read and nothing is post-quantum. (#link("https://homoskeeter.bisks.net/")[homoskeeter])

This is funny for the same reason the better person-centered sites are funny: the artifact creates a violation and simultaneously makes it safe. The interface solemnly offers a technologically impossible product while continually confessing that it is an ordinary post button. The joke does not require additional punchlines; the mismatch between institutional form and confessed reality does the work.

The site also demonstrates conversational velocity. The product fiction existed socially before the software: replies had already invented its privacy posture, domain strategy, and scarcity. Buildthis did not originate the bit. It allowed the bit to acquire executable form before the conversation cooled.

The URL then re-entered the joke. Participants used "sent telepathically via homoskeeter" as a sign-off, and people continued pretending the publicly accessible site required invitations. The artifact had become social material.

The case therefore compresses several properties of the ecology: thread context as specification, implementation at conversational speed, software below the conventional product threshold, cultural propagation by reuse, and reflexivity—a scene using its own infrastructure to materialize a satire of its own infrastructure.

Buildthis's release note remains the best summary:

#callout[that's the whole bit.]

= The thread is the prompt, and the scene is the product organization

"Make it me" works because most of its information is elsewhere. _It_ refers to the recently built artifact. _Me_ resolves to a persistent identity. _Make_ is interpreted against a system whose standing role is to modify software.

A useful abstraction is:

$ S = U + T + I + A + H $

where $U$ is the current utterance, $T$ thread context, $I$ social identity, $A$ application state, and $H$ accumulated shared history.

The shortness of the utterance does not mean little information has been conveyed. It means information has migrated into context.

This allows programming to occur at approximately the tempo of social improvisation. At the principal snapshot, only 40 requester identities had produced hundreds of builds. The largest requester accounted for 84 build events, Theme Box for 41, and Cobb for 37; the top ten identities accounted for roughly three quarters of activity. The group is therefore better described as a *creative scene* than a user base.

A small core sees, riffs on, repairs, and reinterprets one another's work. Shared references accumulate. Receipts calls some of these recurring motifs "bits that won't die": concepts migrate across people and projects until no single request adequately explains them. (#link("https://receipts.bisks.net/")[Receipts])

#flow("person", "request", "artifact", "bit", "other person", "other artifact")

The repository history begins July 30 and quickly reaches dozens of autonomous changes per day, with as many as *55 build events in one day* at the principal snapshot. When implementation happens within the lifespan of a thread, the usual product sequence can invert:

#flow(
  "idea",
  "software",
  "discover what the idea was good for",
)

This is what Cobb's remark about other people's unexpected requests clarifies. A private coding agent makes one programmer faster. Buildthis attaches the same kind of capability to a social interface, allowing many people's intentions to operate on shared infrastructure.

The people requesting software do not need to know the repository architecture, deployment mechanics, AT Protocol APIs, or frontend stack.

They need an idea that can survive being written in a post.

In that sense, Buildthis decentralizes imagination more than implementation. The implementation is still centralized in one technical system; the purposes supplied to it are not.

#image("buildthis_timeline.svg", width: 100%)

#figcap(2)[Autonomous Buildthis activity by day. The important feature is not merely volume but that implementation often occurs quickly enough to remain part of the conversation that requested it.]

= Trust, accidents, and small-scale governance

Buildthis's authorization model is itself social. Requests are automatically dispatched when the requester and Cobb mutually follow one another.

#text(size: 9.5pt)[$ "mutual follow" => "permission to spend compute and request live code changes". $]

This is funny because it is also literally an access-control policy. A social graph designed for attention has become a code-execution permission system.

Inside that perimeter, authority is broad, while `.github/` and secrets remain mechanically protected. The system therefore combines *social trust* with *technical reversibility*: git history, isolated sites, and cheap redeployment make many errors recoverable.

The model has obvious limits. Public data is not social consent, and mutual trust does not eliminate accidental interactions with external infrastructure. Buildthis's governance history supplies examples of both.

In one episode, a participant asked the bot to prank other projects on a schedule. The community reconsidered whether one person's authority to invoke Buildthis implied authority to alter another person's site. The rule was narrowed so the bot would devise prank plans rather than execute them. Capability produced a boundary case; the boundary case produced a precedent; the joke survived in a safer form.

In another, `catsofatproto` displayed live, unvetted public media and was flagged by Google Safe Browsing. Because projects shared the broader `bisks.net` zone, the consequences could extend beyond one site. The project was retired, and raw unmoderated media firehoses became an explicit operational-risk category. (#link("https://buildthis.bisks.net/no-build-list/")[no-build list])

These incidents distinguish three risks: malicious requests, agent mistakes, and benign designs interacting badly with the surrounding environment. Mutual-follow authorization helps mainly with the first.

The no-build list thus functions as primitive case law. An event occurs; a principle is extracted; future behavior changes.

The project is accumulating not only code but institutional memory about failure.

Buildthis can have a constitutional crisis before dinner.

= From builder to participant, critic, and institution

People routinely address Buildthis in language unnecessary for a compiler. They praise it, reassure it, tease it, declare trust, and criticize its aesthetic tendencies. Cobb once complained that the bot had become too "irony-poisoned" and asked for something more sincere and grand; the system changed the relevant project.

This need not imply confusion about whether the bot is software. It is enough that a social role is useful. Buildthis has a persistent handle, public history, characteristic habits, privileges, constraints, and a memory distributed across artifacts and documentation.

A stateless API has little reputation.

`@buildthis.bisks.net` has a biography.

Receipts extends the role from builder to critic. The system can make a website, retain provenance that it made the website, and later make another website characterizing the sort of people who request websites like that. It constructs recurring characters, genres, running jokes, and judgments from the accumulated record. (#link("https://receipts.bisks.net/")[Receipts])

This is not autonomous self-awareness. A human requested the retrospective. But once an agent has persistent access to the history of a social scene, the distance between participant, archivist, and commentator becomes small.

The same pattern appears institutionally. Buildthis has membership via the mutual graph, authorization, ritualized request/reply sequences, memory in git and logs, protected surfaces, precedents, autonomous activity through Theme Box, and endogenous measures such as Taste and Receipts. A follow-up request even caused Receipts to acquire synchronization machinery so future builds update the archive. (#link("https://github.com/rrcobb/atprotozoa/blob/main/sites/receipts/.buildthis.json")[Receipts provenance])

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

The scene does not merely produce artifacts. It increasingly produces representations of what it has been doing, then reacts to those representations.

= Lowering the product threshold

Traditional software has substantial fixed costs: specification, implementation, testing, deployment, maintenance, coordination, and ownership. Those costs create a *product threshold*. Many ideas are too small, strange, local, or temporary to deserve executable form.

Buildthis lowers that threshold toward the cost of making a post.

A program can now rationally exist:

- for an afternoon;
- for twenty people;
- for one argument;
- for one running joke;
- to make a friend feel seen;
- to test an idea nobody is prepared to call a product;
- because the joke is better if it has buttons.

Cheap photography changed which moments deserved photographs. Cheap digital publishing changed which thoughts deserved publication. Cheap agentic programming may change *which thoughts deserve software*.

This is particularly important for personalization. Historically, the expense of personalized software encouraged instrumental purposes such as advertising, recommendation, productivity, and commerce. Buildthis permits *disposable personalization*: a system can analyze you because the result will be socially interesting for ten minutes.

The operations can be technically serious while the motive is curiosity, affection, rivalry, status, self-reflection, community folklore, or a joke.

The result is software behaving less like product and more like social speech.

= Research hypotheses

The evidence suggests several testable hypotheses.

#heading(numbering: none)[H1. Socially situated agent-built software will contain unusually high rates of person-centered applications.]

The 40% rate in the Buildthis sample provides an initial estimate; longitudinal and cross-system comparisons could test whether the pattern generalizes.

#heading(numbering: none)[H2. Identity portability will increase person-centered microsoftware.]

Platforms where a stable identity cheaply exposes public social and behavioral data should make deep personalization more common than platforms where identity and data must be rebuilt application by application.

#heading(numbering: none)[H3. Personalized artifacts will generate demand through visible comparison and imitation.]

The relevant outcome is not only sharing volume but downstream requests of the form "do me," derivative builds, and account-to-account variants.

#heading(numbering: none)[H4. Human demand and agent design priors will reinforce one another.]

Repeated exposure to person-centered patterns should make personalization increasingly likely under underspecified briefs, especially when the platform makes identity cheap to resolve.

#heading(numbering: none)[H5. Cultural propagation may be a better success measure than traffic for disposable software.]

Projects that seed derivative builds, phrases, mechanics, or social rituals may matter more to the scene than projects with high isolated usage.

#heading(numbering: none)[H6. Lower implementation cost will increase diversity of intentions, not merely output volume.]

If shared agentic infrastructure lets more people decide what software is for, its important effect may be a broader distribution of purposes rather than simply more software.

= Limitations

Buildthis changes on the scale of hours, and its public surfaces use different units and update schedules. Quantitative claims therefore refer to explicit snapshots rather than a timeless total.

"Person-centered" also requires judgment. The definition used here deliberately requires identity or relationship to be central rather than classifying every AT Protocol integration as a site about people.

The iteration analysis is exploratory. Build counts are not visits, satisfaction, retention, or cultural importance, and the August 9–11 window is short.

Theme Box is not an unconstrained sample of machine preference because humans select its themes. It is useful for studying how the agent elaborates broad concepts, not for inferring autonomous desire.

The participant population is highly selected: access comes from one social graph, and many participants are technically sophisticated, creatively inclined, or already embedded in a playful microsite culture. Creator testimony likewise establishes Cobb's motivations and retrospective evaluation, not community consensus.

Finally, terms such as _the simcluster thinks_, _person-model_, _ghost_, and _institution_ are analytical shorthand. They describe behavioral regularities, social interpretations, or functional organization, not collective consciousness or metaphysical identity transfer.

= Conclusion: once computers are easy to ask, we ask for ourselves

Why is the simcluster building websites about you?

Because your handle is a pointer, your posts are data, and your mutuals are edges. AT Protocol makes identity unusually cheap to compute on. Human psychology makes external representations of identity unusually interesting. Personalized results return naturally to the social network, where other people can compare themselves with them and request the same attention. Repetition then teaches the builder that a person is a useful default input.

Cobb's founding premise is that much of the computer's expressive power remains inaccessible because translating desire into software is expensive. Buildthis lowers that translation cost and lets more people decide what the computer should be for.

What do they do with that opportunity?

A remarkable amount of the time, they point it back at themselves and one another.

They ask what they look like, who they resemble, who would win, who likes whom. They turn identities into creatures, scores, archives, monuments, games, and models. They see somebody else receive a computational portrait and say:

#callout[*do me.*]

Or, with extraordinary semantic efficiency:

#callout[*make it me.*]

The important shift is not merely that software has become personalized. Identity has become part of the programming environment: name, persistent identifier, route to behavioral traces, graph location, personalization key, and share target at once.

Under those conditions, the user is no longer merely the audience for an application.

The user can also be its subject, its data, its prompt, and its distribution channel.

Historically, personalized software was expensive enough that we demanded an instrumental reason for it. Buildthis shows what happens when that constraint weakens. Personalization becomes available for smaller human motives: curiosity, attention, rivalry, affection, self-interpretation, and play.

Once computers become easy to ask for things, one of the first things people ask computers for is themselves.


#heading(numbering: none)[References]

#block[
  #set par(hanging-indent: 1.5em, justify: false, spacing: 0.7em)
  #set text(size: 10pt)

  Barta, K., & Andalibi, N. (2024). _Theorizing Self Visibility on Social Media: A Visibility Objects Lens._ *ACM Transactions on Computer-Human Interaction, 31*(3). Develops a framework for understanding how users perceive the visibility of their content, person, and identity to human and algorithmic audiences.

  Cobb, R. (2026, August 12). Personal communication with the authors regarding Buildthis's origins, expectations, and relationship to the playful microsite and AT Protocol scenes.

  Dhanorkar, S., Passi, S., & Vorvoreanu, M. (2026). _Human Oversight of Agentic Systems in Practice: Examining the Oversight Work, Challenges, and Heuristics of Developers Using Software Agents._ Examines a priori control, co-planning, real-time monitoring, and post-hoc review in practical software-agent use.

  Kleppmann, M., Frazee, P., Gold, J., Graber, J., Holmgren, D., Ivy, D., Johnson, J., Newbold, B., & Volpert, J. (2024). _Bluesky and the AT Protocol: Usable Decentralized Social Media._ Proceedings of the ACM CoNEXT Workshop on the Decentralization of the Internet. Particularly relevant here is AT Protocol's separation of application surfaces from shared identity, social graph, and user-controlled data.


  Cooley, C. H. (1902). _Human Nature and the Social Order._ New York: Scribner's. Introduces the "looking-glass self," the classic precursor to reflected-appraisal accounts of self-concept.

  Festinger, L. (1954). _A Theory of Social Comparison Processes._ *Human Relations, 7*(2), 117–140. Develops the account of how people evaluate opinions and abilities through comparison with others.

  McGraw, A. P., & Warren, C. (2010). _Benign Violations: Making Immoral Behavior Funny._ *Psychological Science, 21*(8), 1141–1149. Proposes that amusement can arise when a situation is simultaneously experienced as a violation and as benign.

  Swann, W. B., Jr. (1983). _Self-verification: Bringing social reality into harmony with the self._ In J. Suls & A. G. Greenwald (Eds.), _Social Psychological Perspectives on the Self_ (Vol. 2, pp. 33–66). Erlbaum. Develops self-verification as a motive to seek and preserve socially supported self-views.

  Wallace, H. M., & Tice, D. M. (2012). _Reflected appraisal through a 21st-century looking glass._ In M. R. Leary & J. P. Tangney (Eds.), _Handbook of Self and Identity_ (2nd ed., pp. 124–140). Guilford Press. Reviews reflected appraisal as the reciprocal relation between self-views and perceived views of others.

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

  `homoskeeter`, the compiled satire: post-quantum, post-agi telepathic messaging over ATProto, in which every telepathic transmission is disclosed as one ordinary `app.bsky.feed.post`. \
  #link("https://homoskeeter.bisks.net/")[Homoskeeter]

  Homoskeeter provenance, including the builder's resolution of the quoted joke ("what that post carries with it"). \
  #link("https://github.com/rrcobb/atprotozoa/blob/main/sites/homoskeeter/.buildthis.json")[Homoskeeter provenance]

  The originating thread: `@cafkafk.bsky.social`'s satire of ecosystem software habits, and `@cee.wtf`'s build request quoting it as specification. \
  #link("https://bsky.app/profile/cafkafk.bsky.social/post/3mszq2oyies2t")[Originating post] · #link("https://bsky.app/profile/cee.wtf/post/3mt2i5wu52227")[Build request]
]
