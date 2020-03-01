import { Octokit } from "@octokit/core";
const eventType = 'update'

const octokit = new Octokit({
  auth: process.env.GITHUB_TOKEN
});

try {
  const ownerRepo = process.env.GITHUB_REPOSITORY
  // packages-preview

  const response =  octokit.request(`POST /repos/${ownerRepo}/dispatches`, {
    mediaType: {
      previews: ['everest']
    },
    event_type: `${eventType}`,
    client_payload: {},
  });

} catch (error) {
  octokit.log.error(error);
  process.exit(1);
}
