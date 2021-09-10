data "google_iam_role" "role-owner" {
  name = "roles/owner"
}

data "google_iam_role" "role-editor" {
  name = "roles/editor"
}

data "google_iam_role" "role-viewer" {
  name = "roles/viewer"
}

resource "google_project_iam_member" "iam-owner" {
  for_each = toset(var.iam_member_owner)
  project  = var.project
  role     = data.google_iam_role.role-owner.name
  member   = "user:${each.key}"
}

resource "google_project_iam_member" "iam-editor" {
  for_each = toset(var.iam_member_editor)
  project  = var.project
  role     = data.google_iam_role.role-editor.name
  member   = "user:${each.key}"
}

resource "google_project_iam_member" "iam-viewer" {
  for_each = toset(var.iam_member_viewer)
  project  = var.project
  role     = data.google_iam_role.role-viewer.name
  member   = "user:${each.key}"
}
