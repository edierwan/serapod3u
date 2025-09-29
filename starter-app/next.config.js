
/** @type {import('next').NextConfig} */
const nextConfig = {
  images: {
    remotePatterns: [
      {
        protocol: "https",
        hostname: "**.supabase.co",
        pathname: "/storage/v1/object/public/**",
      },
    ],
  },
  experimental: {
    serverActions: { bodySizeLimit: "2mb" }
  },
  async redirects() {
    return [
      {
        source: '/products',
        destination: '/master/products',
        permanent: true,
      },
      {
        source: '/products/:path*',
        destination: '/master/products/:path*',
        permanent: true,
      },
    ];
  },
};

export default nextConfig;
