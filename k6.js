import http from "k6/http";
import { check, sleep } from "k6";

const BASE_URL =
  "https://nextjs-diazluthfi07-dev.apps.rm1.0a51.p1.openshiftapps.com/route"; // Ganti dengan Route kamu

export let options = {
  stages: [
    { duration: "1m", target: 1000 }, // 10 users selama 1 menit
  ],
};

export default function () {
  http.get(BASE_URL);
  sleep(1);
}
