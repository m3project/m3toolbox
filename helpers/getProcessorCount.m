% returns number of processors

function ncpu = getProcessorCount()

import java.lang.*;

r = Runtime.getRuntime;

ncpu = r.availableProcessors;

end