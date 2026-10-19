# Four Hats

A low-friction daily planner for your phone. It has quick capture, four hats (Calling, Community, Family, Work), a Today's 3 screen, and a Stuck button.
It's a single `index.html` on GitHub Pages, with your tasks stored in Supabase.

## Files

| File | Purpose |
|---|---|
| `index.html` | The whole app |
| `supabase/schema.sql` | Creates the `fh_tasks` table and its row level security policies |
| `manifest.webmanifest`, `icon-*.png` | Home-screen name and icon |

## Setup (about 10 minutes)

1. **Database.** In Supabase, open SQL Editor, then New query. Paste `supabase/schema.sql` and click Run. You can use an existing project, because the table is prefixed `fh_` and won't collide with your other apps.
2. **Keys.** In Project Settings, open API and copy the Project URL and the `anon` public key. Paste both into the SETUP block near the top of the `<script>` in `index.html`.
3. **Auth URLs.** In Authentication, open URL Configuration. Add your Pages URL (e.g. `https://<you>.github.io/four-hats/`) to Redirect URLs, so the sign-up confirmation email links back to the app. If this project's Site URL is already used by another app, leave it alone.
4. **Publish.** Push all the files to a repo and turn on GitHub Pages.
5. **Create your account.** Open the page, tap "Create account", confirm the email, then sign in.
6. **Lock it down.** In Authentication, open Sign In / Providers and turn off "Allow new users to sign up", so nobody else can create an account on your project.
7. **Home screen.** On your iPhone, open the page in Safari, tap Share, then Add to Home Screen. You stay signed in from then on.

## How it works

- **Capture:** type in the bottom bar and tap Add. Choose a hat first, or leave it on Inbox and sort it later.
- **Today:** pick up to 3 tasks. They reset automatically each morning, and unfinished ones go back to their hats.
- **Hats:** see one hat at a time. The sun icon adds a task to Today; the ••• menu edits it, sets the first step, or moves it.
- **Inbox:** tap Ca / Co / Fa / Wo to file an item.
- **Stuck:** shows one task. You write the tiniest first step and run a 5-minute timer.
- Changes save to the phone instantly and sync to Supabase in the background. If you're offline, they sync when you're back.
- Completed tasks stay visible for 14 days and then drop out of view. They're still in the database.

## Privacy

Row level security limits every row to the signed-in owner. For confidential Calling matters, keep titles short and use initials ("Follow up — J."). That way nothing sensitive sits in a task title.

## Later: Jira

The planned approach is a Supabase Edge Function that holds your Jira API token. It pulls your assigned tickets into the Work hat and pushes "done" back to Jira. The browser never sees the token.
