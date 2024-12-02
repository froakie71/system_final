import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

export function middleware(request: NextRequest) {
  const token = request.cookies.get('token')?.value;
  const isAuthPage = request.nextUrl.pathname.startsWith('/auth/');
  const isRootPage = request.nextUrl.pathname === '/';
  const isDashboardPage = request.nextUrl.pathname.startsWith('/dashboard');

  // If trying to access dashboard without auth
  if (isDashboardPage && !token) {
    return NextResponse.redirect(new URL('/auth/login', request.url));
  }

  // If trying to access auth pages while authenticated
  if ((isAuthPage || isRootPage) && token) {
    return NextResponse.redirect(new URL('/dashboard', request.url));
  }

  return NextResponse.next();
}

export const config = {
  matcher: [
    '/',
    '/auth/:path*',
    '/dashboard/:path*',
    '/((?!api|_next/static|_next/image|favicon.ico).*)',
  ],
};
