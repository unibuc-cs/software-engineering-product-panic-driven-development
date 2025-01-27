import sys
import asyncio
from howlongtobeatpy import HowLongToBeat


async def main(query):
    results = await HowLongToBeat().async_search(query)
    print({result.game_name: result.game_id for result in results})


if __name__ == "__main__":
    asyncio.run(main(sys.argv[1]))
