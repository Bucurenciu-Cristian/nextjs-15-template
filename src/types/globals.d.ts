export {}

// Create a type for the roles
export type Roles = 'admin' | 'trainer'

declare global {
  interface CustomJwtSessionClaims {
    metadata: {
      role?: Roles
    }
  }
}
